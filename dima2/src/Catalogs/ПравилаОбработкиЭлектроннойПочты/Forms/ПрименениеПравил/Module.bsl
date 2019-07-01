
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.УчетнаяЗапись) Или Параметры.УчетнаяЗапись.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
		
	УчетнаяЗапись = Параметры.УчетнаяЗапись;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ПравилаОбработкиЭлектроннойПочты.Ссылка КАК Правило,
	|	ЛОЖЬ КАК Применять,
	|	ПравилаОбработкиЭлектроннойПочты.ПредставлениеОтбора,
	|	ПравилаОбработкиЭлектроннойПочты.ПомещатьВПапку
	|ИЗ
	|	Справочник.ПравилаОбработкиЭлектроннойПочты КАК ПравилаОбработкиЭлектроннойПочты
	|ГДЕ
	|	ПравилаОбработкиЭлектроннойПочты.Владелец = &Владелец
	|	И (НЕ ПравилаОбработкиЭлектроннойПочты.ПометкаУдаления)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПравилаОбработкиЭлектроннойПочты.РеквизитДопУпорядочивания";
	
	Запрос.УстановитьПараметр("Владелец", Параметры.УчетнаяЗапись);
	Запрос.УстановитьПараметр("Входящие", НСтр("ru='Входящие';uk='Вхідні'"));
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		ПрименяемыеПравила.Загрузить(Результат.Выгрузить());
	КонецЕсли;
	
	Если Параметры.Свойство("ДляПисемВПапке") И ЗначениеЗаполнено(Параметры.ДляПисемВПапке) Тогда
		ДляПисемВПапке = Параметры.ДляПисемВПапке;
	Иначе 
		
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ПапкиЭлектронныхПисем.Ссылка
		|ИЗ
		|	Справочник.ПапкиЭлектронныхПисем КАК ПапкиЭлектронныхПисем
		|ГДЕ
		|	ПапкиЭлектронныхПисем.ПредопределеннаяПапка
		|	И ПапкиЭлектронныхПисем.Владелец = &Владелец
		|	И ПапкиЭлектронныхПисем.Наименование = &Входящие";
		
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			ДляПисемВПапке = Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	
	ОчиститьСообщения();
	
	ВыбраноХотьОдноПравило = Ложь;
	Отказ = Ложь;
	
	Для каждого Правило Из ПрименяемыеПравила Цикл
		
		Если Правило.Применять Тогда
			ВыбраноХотьОдноПравило = Истина;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ВыбраноХотьОдноПравило Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Необходимо выбрать хотя бы одно правило для применения';uk='Необхідно вибрати хоча б одне правило для застосування'"),,"Список");
		Отказ = Истина;
	КонецЕсли;
	
	Если ДляПисемВПапке.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не выбрана папка к письмам которой будут применены правила';uk='Не вибрана папка до листів якій будуть застосовані правила'"),,"ДляПисемВПапке");
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ПрименитьПравилаНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтотОбъект, ИдентификаторЗадания);
		
	Иначе
		Оповестить("ПримененыПравилаОбработкиПисем");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьВсеПравила(Команда)
	
	Для каждого Строка Из ПрименяемыеПравила Цикл
		Строка.Применять = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НеПрименятьВсеПравила(Команда)
	
	Для каждого Строка Из ПрименяемыеПравила Цикл
		Строка.Применять = Ложь;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПрименитьПравилаНаСервере()
	
	ПараметрыВыгрузки = Новый Структура;
	
	ПараметрыВыгрузки.Вставить("ТаблицаПравил", ПрименяемыеПравила.Выгрузить());
	ПараметрыВыгрузки.Вставить("ДляПисемВПапке", ДляПисемВПапке);
	ПараметрыВыгрузки.Вставить("ВключаяПодчиненные", ВключаяПодчиненные);
	ПараметрыВыгрузки.Вставить("УчетнаяЗапись", УчетнаяЗапись);
	
	ЗаполнитьЗначенияСвойств(ПараметрыВыгрузки, ЭтотОбъект);
	
	НаименованиеЗадания = НСтр("ru='Применение правил';uk='Застосування правил'") + " ";
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Справочники.ПравилаОбработкиЭлектроннойПочты.ПрименитьПравила", 
		ПараметрыВыгрузки,
		НаименованиеЗадания);
		
	АдресХранилища = Результат.АдресХранилища;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьРезультат();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьРезультат()
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(Результат) = Тип("Строка")
		И ЗначениеЗаполнено(Результат) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ЗагрузитьРезультат();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				Оповестить("ПримененыПравилаОбработкиПисем");
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания", 
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

#КонецОбласти
