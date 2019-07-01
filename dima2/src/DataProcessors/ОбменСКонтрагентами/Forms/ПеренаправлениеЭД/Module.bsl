
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ЭД") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ТекущийКомментарий", Комментарий);
	
	ОбъектыДляОбработки = Новый Массив;
	Если ТипЗнч(Параметры.ЭД) <> Тип("Массив") Тогда
		ОбъектыДляОбработки.Добавить(Параметры.ЭД);
	Иначе
		ОбъектыДляОбработки = Параметры.ЭД;
	КонецЕсли;
	АдресХранилища = ПоместитьВоВременноеХранилище(ОбъектыДляОбработки, УникальныйИдентификатор);
	
	Если ОбъектыДляОбработки.Количество() > 1 Тогда
		Элементы.ОбъектыДляОбработки.Заголовок = НСтр("ru='Список';uk='Список'");
	КонецЕсли;
	
	Если Параметры.Свойство("Ответственный") Тогда
		Пользователь = Параметры.Ответственный;
	КонецЕсли;
	Если ОбъектыДляОбработки.Количество() = 1 Тогда
		ЭлектронныйДокумент = ОбъектыДляОбработки[0];
		ТекстГиперссылки = ОбменСКонтрагентамиСлужебный.ПолучитьПредставлениеЭД(ЭлектронныйДокумент);
	Иначе
		ТекстГиперссылки = НСтр("ru='Электронные документы (%1)';uk='Електронні документи (%1)'");
		ТекстГиперссылки = СтрЗаменить(ТекстГиперссылки, "%1", ОбъектыДляОбработки.Количество());
	КонецЕсли;
	
	ТекстГиперссылки = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ТекстГиперссылки);
	НадписьОбъектыДляОбработки = ТекстГиперссылки;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Пользователи.Ссылка
	|ИЗ
	|	Справочник.ЭДПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПрофилиНастроекЭДО.СертификатыПодписейОрганизации КАК ПрофилиНастроекЭДОСертификатыПодписейОрганизации
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК СертификатыКлючейЭлектроннойПодписиИШифрования
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
	|				ПО СертификатыКлючейЭлектроннойПодписиИШифрования.Пользователь = Пользователи.Ссылка
	|			ПО ПрофилиНастроекЭДОСертификатыПодписейОрганизации.Сертификат = СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка
	|		ПО ЭДПрисоединенныеФайлы.ПрофильНастроекЭДО = ПрофилиНастроекЭДОСертификатыПодписейОрганизации.Ссылка
	|ГДЕ
	|	ЭДПрисоединенныеФайлы.Ссылка В(&МассивЭД)";
	
	Запрос.УстановитьПараметр("МассивЭД", ОбъектыДляОбработки);
	РезультатЗапроса = Запрос.Выполнить();
	ПользователиСертификатов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Если ЗначениеЗаполнено(ПользователиСертификатов) Тогда
		Элементы.Пользователь.СписокВыбора.ЗагрузитьЗначения(ПользователиСертификатов);
		Элементы.Пользователь.КнопкаВыпадающегоСписка = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПолейФормы

&НаКлиенте
Процедура ОбъектыДляОбработкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МассивЭД = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если МассивЭД.Количество() > 1 Тогда
		ФормаПросмотраЭД = ОткрытьФорму("Обработка.ОбменСКонтрагентами.Форма.ФормаСпискаВыгружаемыхДокументов",
			Новый Структура("МассивСсылокЭД", МассивЭД), ЭтаФорма);
	Иначе
		ПоказатьЗначение(, МассивЭД[0]);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указан ответственный.';uk='Не вказано відповідальний.'"),, "Пользователь");
		Возврат;
	КонецЕсли;
	ВсегоЭД = 0;
	Результат = ПеренаправитьЭД(ВсегоЭД);
	ОбменСКонтрагентамиСлужебныйКлиент.ОповеститьПользователяОСменеОтветственного(Пользователь, ВсегоЭД, Результат);
	Оповестить("ОбновитьСостояниеЭД");
	Закрыть(Результат > 0);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПеренаправитьЭД(ВсегоЭД)
	
	МассивЭД = ПолучитьИзВременногоХранилища(АдресХранилища);
	ВсегоЭД = МассивЭД.Количество();
	КоличествоОбработанныхЭД = 0;
	ОбменСКонтрагентамиСлужебныйВызовСервера.УстановитьОтветственногоЭД(МассивЭД,
		Пользователь, КоличествоОбработанныхЭД, Комментарий);
	
	Возврат КоличествоОбработанныхЭД;
	
КонецФункции

#КонецОбласти
