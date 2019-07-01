
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		
		Возврат;
		
	КонецЕсли;

	ЗначенияДляЗаполнения = Новый Структура("Организация, Месяц", "Организация", "МесяцНачисления");
	ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "МесяцНачисления", "МесяцНачисленияСтрокой");
	
	ОбновитьНаСервере();
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбновитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "МесяцНачисления", "МесяцНачисленияСтрокой");
	
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцНачисленияСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "МесяцНачисления", "МесяцНачисленияСтрокой", Ложь, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт 
	
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "МесяцНачисления", "МесяцНачисленияСтрокой", Направление);
	
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойАвтоПодбор(Элемент,
	Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойОкончаниеВводаТекста(Элемент,
	Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#Область ОбработчикиСобытийТаблицФормы

&НаКлиенте
Процедура ВыплатаЗарплатыНаличнымиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПоказатьЗначение(, Элемент.ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ВыплатаЗарплатыЧерезБанкВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПоказатьЗначение(, Элемент.ТекущиеДанные.Ссылка);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьНаСервере();
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	ОбъектыПечати = Новый Массив;
	ОбъектыПечати.Добавить(ЭтаФорма.Организация);
	ОбъектыПечати.Добавить(ЭтаФорма.МесяцНачисления);
	ОбъектыПечати.Добавить(ЭтаФорма.ОбщийИтог);
	ОбъектыПечати.Добавить(ЭтаФорма.ВыплатаЗарплатыНаличными);
	ОбъектыПечати.Добавить(ЭтаФорма.ВыплатаЗарплатыЧерезБанк);
	ОбъектыПечати.Добавить(ЭтаФорма.Налоги);
	ОбъектыПечати.Добавить(ЭтаФорма.СтраховыеВзносы);
	ОбъектыПечати.Добавить(ЭтаФорма.УдержанияПоИсполнительнымДокументам);
	ОбъектыПечати.Добавить(ЭтаФорма.УдержанияВПользуТретьихЛиц);
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, ОбъектыПечати);

КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьНаСервере()
	
	// Необходимость проверки обусловлена включением привилегированного режима.
	Если Не ЕстьДоступКДаннымОрганизации() Тогда
		
		ЭтаФорма.ВыплатаЗарплатыНаличными.Очистить();
		ЭтаФорма.ВыплатаЗарплатыЧерезБанк.Очистить();
		ЭтаФорма.Налоги.Очистить();
		ЭтаФорма.СтраховыеВзносы.Очистить();
		ЭтаФорма.УдержанияПоИсполнительнымДокументам.Очистить();
		ЭтаФорма.УдержанияВПользуТретьихЛиц.Очистить();
		ЭтаФорма.ИтогВыплатаЗарплатыНаличными = 0;
		ЭтаФорма.ИтогВыплатаЗарплатыЧерезБанк = 0;
		ЭтаФорма.ИтогНалоги = 0;
		ЭтаФорма.ИтогСтраховыеВзносы = 0;
		ЭтаФорма.ИтогУдержанияПоИсполнительнымДокументам = 0;
		ЭтаФорма.ИтогАгентаУдержанияПоИсполнительнымДокументам = 0;
		ЭтаФорма.ИтогУдержанияВПользуТретьихЛиц = 0;
		ЭтаФорма.ОбщийИтог = 0;
		
		СтрокаПодстановки = НСтр("ru='Получение данных организации %1 запрещено для текущего пользователя.';uk='Отримання даних організації %1 заборонено для поточного користувача.'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаПодстановки, ЭтаФорма.Организация);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);
		Возврат;
		
	КонецЕсли;

	ЭтаФорма.ОбщийИтог = 0;

	ЗаполнитьВыплатуЗарплатыНаличными();	
	ЗаполнитьВыплатуЗарплатыЧерезБанк();	
	//ЗаполнитьВыплатуНалогов();          	
	//ЗаполнитьВыплатуСтраховыхВзносов(); 	
	ЗаполнитьВыплатуУдержанийПоИсполнительнымДокументам();	
	ЗаполнитьВыплатуУдержанийВПользуТретьихЛиц();
		
КонецПроцедуры

&НаСервере
Функция ЕстьДоступКДаннымОрганизации()
	
	Если ЭтаФорма.Организация = Справочники.Организации.ПустаяСсылка() Тогда
		Возврат Истина;
	КонецЕсли;	
		
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Объект
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|	И Организации.Ссылка = &Организация";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Организация", ЭтаФорма.Организация);

	ЕстьДоступ = НЕ Запрос.Выполнить().Пустой();
	
	Возврат ЕстьДоступ;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьВыплатуЗарплатыНаличными()
	
	ЭтаФорма.ВыплатаЗарплатыНаличными.Очистить();
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =  
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ВедомостьНаВыплатуЗарплатыВКассу.Касса = ЗНАЧЕНИЕ(Справочник.Кассы.ПустаяСсылка)
	|			ТОГДА &КассаНеУказана
	|		ИНАЧЕ ВедомостьНаВыплатуЗарплатыВКассу.Касса
	|	КОНЕЦ КАК МестоВыплаты,
	|	ВедомостьНаВыплатуЗарплатыВКассу.СпособВыплаты КАК СпособВыплаты,
	|	ВедомостьНаВыплатуЗарплатыВКассу.СуммаПоДокументу КАК Сумма,
	|	ВедомостьНаВыплатуЗарплатыВКассу.Ссылка
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВКассу КАК ВедомостьНаВыплатуЗарплатыВКассу
	|ГДЕ
	|	ВедомостьНаВыплатуЗарплатыВКассу.ПериодРегистрации = &ПериодРегистрации
	|	И ВедомостьНаВыплатуЗарплатыВКассу.Организация = &Организация
	|	И ВедомостьНаВыплатуЗарплатыВКассу.Проведен = ИСТИНА
	|	И ВедомостьНаВыплатуЗарплатыВКассу.СуммаПоДокументу <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВедомостьНаВыплатуЗарплатыРаздатчиком.Раздатчик,
	|	ВедомостьНаВыплатуЗарплатыРаздатчиком.СпособВыплаты,
	|	ВедомостьНаВыплатуЗарплатыРаздатчиком.СуммаПоДокументу,
	|	ВедомостьНаВыплатуЗарплатыРаздатчиком.Ссылка
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыРаздатчиком КАК ВедомостьНаВыплатуЗарплатыРаздатчиком
	|ГДЕ
	|	ВедомостьНаВыплатуЗарплатыРаздатчиком.ПериодРегистрации = &ПериодРегистрации
	|	И ВедомостьНаВыплатуЗарплатыРаздатчиком.Организация = &Организация
	|	И ВедомостьНаВыплатуЗарплатыРаздатчиком.Проведен = ИСТИНА
	|	И ВедомостьНаВыплатуЗарплатыРаздатчиком.СуммаПоДокументу <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	СпособВыплаты,
	|	МестоВыплаты";
	
	Запрос.УстановитьПараметр("Организация", ЭтаФорма.Организация);
	Запрос.УстановитьПараметр("ПериодРегистрации", ЭтаФорма.МесяцНачисления);
	Запрос.УстановитьПараметр("КассаНеУказана", "<" + НСтр("ru='Касса не указана';uk='Каса не вказана'") + ">");
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл		
		НоваяВыплата = ЭтаФорма.ВыплатаЗарплатыНаличными.Добавить();		
		ЗаполнитьЗначенияСвойств(НоваяВыплата, ВыборкаДетальныеЗаписи);
	КонецЦикла;
	
	ИтогоКВыплате = ЭтаФорма.ВыплатаЗарплатыНаличными.Итог("Сумма");
	ЭтаФорма.ИтогВыплатаЗарплатыНаличными = ИтогоКВыплате;
	ЭтаФорма.ОбщийИтог = ЭтаФорма.ОбщийИтог + ИтогоКВыплате;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВыплатуЗарплатыЧерезБанк()
	
	ЭтаФорма.ВыплатаЗарплатыЧерезБанк.Очистить();
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =  
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Сотрудники.Ссылка
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	Справочник.Сотрудники КАК Сотрудники
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА ВедомостьНаВыплатуЗарплатыВБанк.ЗарплатныйПроект = ЗНАЧЕНИЕ(Справочник.ЗарплатныеПроекты.ПустаяСсылка)
	|			ТОГДА &ЗарплатныйПроектНеУказан
	|		ИНАЧЕ ВедомостьНаВыплатуЗарплатыВБанк.ЗарплатныйПроект
	|	КОНЕЦ КАК МестоВыплаты,
	|	ВедомостьНаВыплатуЗарплатыВБанк.СпособВыплаты,
	|	ВедомостьНаВыплатуЗарплатыВБанк.СуммаПоДокументу КАК Сумма,
	|	ВедомостьНаВыплатуЗарплатыВБанк.Ссылка,
	|	NULL КАК НомерСчета,
	|	NULL КАК Банк,
	|	NULL КАК ФизическоеЛицо
	|ПОМЕСТИТЬ ВТВедомости
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк КАК ВедомостьНаВыплатуЗарплатыВБанк
	|ГДЕ
	|	ВедомостьНаВыплатуЗарплатыВБанк.ПериодРегистрации = &ПериодРегистрации
	|	И ВедомостьНаВыплатуЗарплатыВБанк.Организация = &Организация
	|	И ВедомостьНаВыплатуЗарплатыВБанк.Проведен = ИСТИНА
	|	И ВедомостьНаВыплатуЗарплатыВБанк.СуммаПоДокументу <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	NULL,
	|	ВедомостьНаВыплатуЗарплатыПеречислением.Ссылка.СпособВыплаты,
	|	ВедомостьНаВыплатуЗарплатыПеречислением.КВыплате,
	|	ВедомостьНаВыплатуЗарплатыПеречислением.Ссылка,
	|	ВедомостьНаВыплатуЗарплатыПеречислением.БанковскийСчет.НомерСчета,
	|	ВедомостьНаВыплатуЗарплатыПеречислением.БанковскийСчет.Банк.Наименование,
	|	ВедомостьНаВыплатуЗарплатыПеречислением.Сотрудник.ФизическоеЛицо
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыПеречислением.Зарплата КАК ВедомостьНаВыплатуЗарплатыПеречислением
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.БанковскиеСчетаКонтрагентов КАК БанковскиеСчетаКонтрагентов
	|		ПО ВедомостьНаВыплатуЗарплатыПеречислением.Сотрудник.ФизическоеЛицо = БанковскиеСчетаКонтрагентов.Владелец
	|ГДЕ
	|	ВедомостьНаВыплатуЗарплатыПеречислением.Сотрудник В
	|			(ВЫБРАТЬ
	|				Сотрудники.Ссылка
	|			ИЗ
	|				ВТСотрудники КАК Сотрудники)
	|	И ВедомостьНаВыплатуЗарплатыПеречислением.Ссылка.ПериодРегистрации = &ПериодРегистрации
	|	И ВедомостьНаВыплатуЗарплатыПеречислением.Ссылка.Организация = &Организация
	|	И ВедомостьНаВыплатуЗарплатыПеречислением.Ссылка.Проведен = ИСТИНА
	|	И ВедомостьНаВыплатуЗарплатыПеречислением.Ссылка.СуммаПоДокументу <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТВедомости.ФизическоеЛицо
	|ИЗ
	|	ВТВедомости КАК ВТВедомости
	|ГДЕ
	|	ВТВедомости.ФизическоеЛицо ЕСТЬ НЕ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТВедомости.МестоВыплаты КАК МестоВыплаты,
	|	ВТВедомости.СпособВыплаты КАК СпособВыплаты,
	|	ВТВедомости.Сумма,
	|	ВТВедомости.Ссылка,
	|	ВТВедомости.НомерСчета,
	|	ВТВедомости.Банк КАК Банк,
	|	ВТВедомости.ФизическоеЛицо
	|ИЗ
	|	ВТВедомости КАК ВТВедомости
	|
	|УПОРЯДОЧИТЬ ПО
	|	СпособВыплаты,
	|	МестоВыплаты,
	|	Банк";
	
	Запрос.УстановитьПараметр("Организация", ЭтаФорма.Организация);
	Запрос.УстановитьПараметр("ПериодРегистрации", ЭтаФорма.МесяцНачисления);
	Запрос.УстановитьПараметр("ЗарплатныйПроектНеУказан", "<" + НСтр("ru='Зарплатный проект не указан';uk='Зарплатний проект не вказано'") + ">");
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаФизическиеЛица = РезультатЗапроса[2].Выгрузить();
	
	Если ВыборкаФизическиеЛица.Количество() > 0 Тогда
		ФизическиеЛицаВедомостей = ВыборкаФизическиеЛица.ВыгрузитьКолонку("ФизическоеЛицо");
		ДанныеФизическихЛиц = КадровыйУчет.КадровыеДанныеФизическихЛиц(
			Истина, ФизическиеЛицаВедомостей,	"ФИОПолные", НачалоМесяца(МесяцНачисления));
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса[3].Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл		
		
		НоваяВыплата = ЭтаФорма.ВыплатаЗарплатыЧерезБанк.Добавить();		
		
		ЗаполнитьЗначенияСвойств(НоваяВыплата, ВыборкаДетальныеЗаписи);
		
		Если ТипЗнч(НоваяВыплата.Ссылка) = Тип("ДокументСсылка.ВедомостьНаВыплатуЗарплатыПеречислением") Тогда
			
			ФИОФизлица = "";
			
			ДанныеФизическогоЛица = ДанныеФизическихЛиц.Найти(ВыборкаДетальныеЗаписи.ФизическоеЛицо, "ФизическоеЛицо");
				
			Если ДанныеФизическогоЛица <> Неопределено Тогда
				ФИОФизлица = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ДанныеФизическогоЛица.ФИОПолные);
			КонецЕсли;
				
			СтрокаПодстановки = НСтр("ru='%1 (%2)';uk='%1 (%2)'");
			
			НоваяВыплата["МестоВыплаты"] = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				СтрокаПодстановки, ФИОФизлица, ВыборкаДетальныеЗаписи["Банк"]);
				
		КонецЕсли;
		
	КонецЦикла;
	
	ИтогоКВыплате = ЭтаФорма.ВыплатаЗарплатыЧерезБанк.Итог("Сумма");
	ЭтаФорма.ИтогВыплатаЗарплатыЧерезБанк = ИтогоКВыплате;
	ЭтаФорма.ОбщийИтог = ЭтаФорма.ОбщийИтог + ИтогоКВыплате;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВыплатуУдержанийПоИсполнительнымДокументам()
	
	ЭтаФорма.УдержанияПоИсполнительнымДокументам.Очистить();
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =  
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФизическиеЛица.Ссылка
	|ПОМЕСТИТЬ ВТФизическиеЛица
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	БанковскиеСчетаКонтрагентов.Владелец КАК Владелец,
	|	МИНИМУМ(БанковскиеСчетаКонтрагентов.Ссылка) КАК СчетаКонтрагента
	|ПОМЕСТИТЬ ВТБанковскиеСчетаКонтрагентов
	|ИЗ
	|	Справочник.БанковскиеСчетаКонтрагентов КАК БанковскиеСчетаКонтрагентов
	|
	|СГРУППИРОВАТЬ ПО
	|	БанковскиеСчетаКонтрагентов.Владелец
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УдержанияПоИсполнительнымДокументамОбороты.ПлатежныйАгент КАК ПлатежныйАгент,
	|	УдержанияПоИсполнительнымДокументамОбороты.Получатель КАК Получатель,
	|	УдержанияПоИсполнительнымДокументамОбороты.ИсполнительныйДокумент.АдресПолучателяПредставление КАК АдресПолучателя,
	|	УдержанияПоИсполнительнымДокументамОбороты.СуммаУдержанияОборот КАК Сумма,
	|	УдержанияПоИсполнительнымДокументамОбороты.СуммаВознагражденияПлатежногоАгентаОборот КАК ВознаграждениеАгента,
	|	ВТБанковскиеСчетаКонтрагентов.СчетаКонтрагента.Банк КАК БанкПолучателя,
	|	ВТБанковскиеСчетаКонтрагентов.СчетаКонтрагента.НомерСчета КАК СчетПолучателя,
	|	УдержанияПоИсполнительнымДокументамОбороты.ИсполнительныйДокумент.Номер КАК Номер,
	|	УдержанияПоИсполнительнымДокументамОбороты.ИсполнительныйДокумент.Дата КАК Дата
	|ИЗ
	|	РегистрНакопления.УдержанияПоИсполнительнымДокументам.Обороты(
	|			&ПериодРегистрации,
	|			КОНЕЦПЕРИОДА(&ПериодРегистрации, МЕСЯЦ),
	|			Месяц,
	|			Организация = &Организация
	|				И ФизическоеЛицо В
	|					(ВЫБРАТЬ
	|						ФизическиеЛица.Ссылка
	|					ИЗ
	|						ВТФизическиеЛица КАК ФизическиеЛица)) КАК УдержанияПоИсполнительнымДокументамОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТБанковскиеСчетаКонтрагентов КАК ВТБанковскиеСчетаКонтрагентов
	|		ПО УдержанияПоИсполнительнымДокументамОбороты.Получатель = ВТБанковскиеСчетаКонтрагентов.Владелец
	|
	|УПОРЯДОЧИТЬ ПО
	|	Получатель,
	|	Дата
	|ИТОГИ
	|	СУММА(Сумма),
	|	СУММА(ВознаграждениеАгента)
	|ПО
	|	Получатель,
	|	ПлатежныйАгент";
	
	Запрос.УстановитьПараметр("Организация", ЭтаФорма.Организация);
	Запрос.УстановитьПараметр("ПериодРегистрации", ЭтаФорма.МесяцНачисления);
	
	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаПолучатель = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Получатель");
	
	Пока ВыборкаПолучатель.Следующий() Цикл		
		
		ВыборкаАгент = ВыборкаПолучатель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ПлатежныйАгент");
		
		Пока ВыборкаАгент.Следующий() Цикл		
			
			НоваяВыплата = ЭтаФорма.УдержанияПоИсполнительнымДокументам.Добавить();		
			ЗаполнитьЗначенияСвойств(НоваяВыплата, ВыборкаАгент);
			
			ВыборкаДетальныеЗаписи = ВыборкаАгент.Выбрать();
			
			Если ВыборкаДетальныеЗаписи.Количество() = 1 Тогда
				НоваяВыплата.ИсполнительныеЛисты = НСтр("ru='По документу';uk='По документу'") + " ";
			ИначеЕсли ВыборкаДетальныеЗаписи.Количество() > 1 Тогда
				НоваяВыплата.ИсполнительныеЛисты = НСтр("ru='По документам';uk='По документах'") + " ";
			КонецЕсли;			
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				
				НоваяВыплата.АдресПолучателя = ВыборкаДетальныеЗаписи.АдресПолучателя;
				
				СтрокаПодстановки = НСтр("ru='%1 в %2';uk='%1 у %2'");

				Если СтрДлина(ВыборкаДетальныеЗаписи.СчетПолучателя) > 0 Тогда
					НоваяВыплата.СчетПолучателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						СтрокаПодстановки, ВыборкаДетальныеЗаписи.СчетПолучателя, ВыборкаДетальныеЗаписи.БанкПолучателя);
				КонецЕсли;					
				
				СтрокаПодстановки = НСтр("ru='№ %1 от %2';uk='№ %1 від %2'");
				ПредставлениеИсполнительногоЛиста = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					СтрокаПодстановки, ВыборкаДетальныеЗаписи.Номер, Формат(ВыборкаДетальныеЗаписи.Дата, "ДЛФ=D"));
					
				НоваяВыплата.ИсполнительныеЛисты =
					НоваяВыплата.ИсполнительныеЛисты + ПредставлениеИсполнительногоЛиста + ", ";

			КонецЦикла;
			
			Если ВыборкаДетальныеЗаписи.Количество() >= 1 Тогда
				НоваяВыплата.ИсполнительныеЛисты = Лев(НоваяВыплата.ИсполнительныеЛисты,
					СтрДлина(НоваяВыплата.ИсполнительныеЛисты) - СтрДлина(", "));
			КонецЕсли;
				
		КонецЦикла;
		
	КонецЦикла;
	
	ИтогоКВыплате = ЭтаФорма.УдержанияПоИсполнительнымДокументам.Итог("Сумма");
	ИтогоКВыплатеАгенту = ЭтаФорма.УдержанияПоИсполнительнымДокументам.Итог("ВознаграждениеАгента");
	
	ЭтаФорма.ИтогУдержанияПоИсполнительнымДокументам = ИтогоКВыплате;
	ЭтаФорма.ИтогАгентаУдержанияПоИсполнительнымДокументам = ИтогоКВыплатеАгенту;
	
	ЭтаФорма.ОбщийИтог = ЭтаФорма.ОбщийИтог + ИтогоКВыплате + ИтогоКВыплатеАгенту;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВыплатуУдержанийВПользуТретьихЛиц()
	
	ЭтаФорма.УдержанияВПользуТретьихЛиц.Очистить();
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =  
	"ВЫБРАТЬ
	|	ПолучателиУдержаний.Контрагент КАК Контрагент,
	|	СУММА(НачисленияУдержанияПоСотрудникам.Сумма) КАК Сумма
	|ИЗ
	|	РегистрНакопления.НачисленияУдержанияПоСотрудникам КАК НачисленияУдержанияПоСотрудникам
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПолучателиУдержаний КАК ПолучателиУдержаний
	|		ПО НачисленияУдержанияПоСотрудникам.ДокументОснование = ПолучателиУдержаний.ДокументОснование
	|			И НачисленияУдержанияПоСотрудникам.Организация = ПолучателиУдержаний.Организация
	|			И НачисленияУдержанияПоСотрудникам.ФизическоеЛицо = ПолучателиУдержаний.ФизическоеЛицо
	|ГДЕ
	|	НачисленияУдержанияПоСотрудникам.Период = &ПериодРегистрации
	|	И НачисленияУдержанияПоСотрудникам.Организация = &Организация
	|	И НачисленияУдержанияПоСотрудникам.ГруппаНачисленияУдержанияВыплаты = ЗНАЧЕНИЕ(Перечисление.ГруппыНачисленияУдержанияВыплаты.Удержано)
	|	И ТИПЗНАЧЕНИЯ(НачисленияУдержанияПоСотрудникам.НачислениеУдержание) = ТИП(ПланВидовРасчета.Удержания)
	|	И (НачисленияУдержанияПоСотрудникам.НачислениеУдержание.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ПрофсоюзныеВзносы)
	|			ИЛИ НачисленияУдержанияПоСотрудникам.НачислениеУдержание.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ДобровольныеВзносыВНПФ)
	|			ИЛИ НачисленияУдержанияПоСотрудникам.НачислениеУдержание.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ПрочееУдержаниеВПользуТретьихЛиц))
	|
	|СГРУППИРОВАТЬ ПО
	|	ПолучателиУдержаний.Контрагент";
	
	Запрос.УстановитьПараметр("Организация", ЭтаФорма.Организация);
	Запрос.УстановитьПараметр("ПериодРегистрации", ЭтаФорма.МесяцНачисления);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл		
		НоваяВыплата = ЭтаФорма.УдержанияВПользуТретьихЛиц.Добавить();		
		ЗаполнитьЗначенияСвойств(НоваяВыплата, ВыборкаДетальныеЗаписи);
	КонецЦикла;
	
	ИтогоКВыплате = ЭтаФорма.УдержанияВПользуТретьихЛиц.Итог("Сумма");
	ЭтаФорма.ИтогУдержанияВПользуТретьихЛиц = ИтогоКВыплате;
	ЭтаФорма.ОбщийИтог = ЭтаФорма.ОбщийИтог + ИтогоКВыплате;
	
КонецПроцедуры

#КонецОбласти
