
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	УправлениеЭлементами()
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда
		// Изменены настройки программы в панелях администрирования
		УправлениеЭлементами();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ОбщиеСправочники

&НаКлиенте
Процедура ОткрытьСправочникВидыДоходовНДФЛ(Команда)
	
	ОткрытьФорму("Справочник.ВидыДоходовНДФЛ.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьСправочникВидыЛьготПоНДФЛ(Команда)
	
	ОткрытьФорму("Справочник.ВидыЛьготПоНДФЛ.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРегистрСведенийРазмерЛьготНДФЛ(Команда)
	
	ОткрытьФорму("РегистрСведений.РазмерыЛьготНДФЛ.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРегистрСведенийТарифыСтраховыхВзносов(Команда)
	
	ОткрытьФорму("РегистрСведений.ШкалаСтавокНалогов.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникКатегорииЗастрахованныхЛицЕСВ(Команда)
	
	ОткрытьФорму("Справочник.КатегорииЗастрахованныхЛицЕСВ.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьГрафикиРаботыСотрудников(Команда)
	
	ОткрытьФорму("Справочник.ГрафикиРаботыСотрудников.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникВидыИспользованияРабочегоВремени(Команда)
	
	ОткрытьФорму("Справочник.ВидыИспользованияРабочегоВремени.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникВидыРаботСотрудников(Команда)
	
	ОткрытьФорму("Справочник.ВидыРаботСотрудников.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПланВидовРасчетаНачисления(Команда)
	
	ОткрытьФорму("ПланВидовРасчета.Начисления.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПланВидовРасчетаУдержания(Команда)
	
	ОткрытьФорму("ПланВидовРасчета.Удержания.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникПоказателиРасчетаЗарплаты(Команда)
	
	ОткрытьФорму("Справочник.ПоказателиРасчетаЗарплаты.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникПодразделенияОрганизаций(Команда)
	
	ОткрытьФорму("Справочник.ПодразделенияОрганизаций.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникДолжности(Команда)
	
	ОткрытьФорму("Справочник.Должности.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникВидыДокументовВводДанныхДляРасчетаЗарплаты(Команда)
	
	ОткрытьФорму("Справочник.ВидыДокументовВводДанныхДляРасчетаЗарплаты.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникСпособыОтраженияЗарплатыВБухУчете(Команда)
	
	ОткрытьФорму("Справочник.СпособыОтраженияЗарплатыВБухУчете.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникГруппыУчетаНачисленийИУдержаний(Команда)
	
	ОткрытьФорму("Справочник.ГруппыУчетаНачисленийИУдержаний.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьЗарплатныеПроекты(Команда)
	
	ОткрытьФорму("Справочник.ЗарплатныеПроекты.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМестаРаботы(Команда)
	
	ОткрытьФорму("Справочник.МестаРаботы.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеЭлементами()
	
	//Права просмотра нормативно-справочной информации.
	ПравоДоступаПодразделения        = ПравоДоступа("Просмотр", Метаданные.Справочники.ПодразделенияОрганизаций);
	ПравоДоступаДолжности            = ПравоДоступа("Просмотр", Метаданные.Справочники.Должности);
	ПравоДоступаГрафикиРаботыСотрудников = ПравоДоступа("Просмотр", Метаданные.Справочники.ГрафикиРаботыСотрудников);
	ПравоДоступаВидыРаботСотрудников = ПравоДоступа("Просмотр", Метаданные.Справочники.ВидыРаботСотрудников);
	ПравоДоступаВидыИспользованияРабочегоВремени = ПравоДоступа("Просмотр", Метаданные.Справочники.ВидыИспользованияРабочегоВремени);
	ПравоДоступаЗарплатныеПроекты    = ПравоДоступа("Просмотр", Метаданные.Справочники.ЗарплатныеПроекты);
	ПравоДоступаМестаРаботы          = ПравоДоступа("Просмотр", Метаданные.Справочники.МестаРаботы);
	ПравоДоступаСпособыВыплаты       = ПравоДоступа("Просмотр", Метаданные.Справочники.СпособыВыплатыЗарплаты);
	ПравоДоступаСпособыОкругления    = ПравоДоступа("Просмотр", Метаданные.Справочники.СпособыОкругленияПриРасчетеЗарплаты);
	
	//Права просмотра данных для расчета.
	ПравоДоступаНачисления                  = ПравоДоступа("Просмотр", Метаданные.ПланыВидовРасчета.Начисления);
	ПравоДоступаУдержания                   = ПравоДоступа("Просмотр", Метаданные.ПланыВидовРасчета.Удержания);
	ПравоДоступаПоказателиРасчетаЗарплаты   = ПравоДоступа("Просмотр", Метаданные.Справочники.ПоказателиРасчетаЗарплаты);
	ПравоДоступаВидыДокументовВводДанныхДляРасчетаЗарплаты = ПравоДоступа("Просмотр", Метаданные.Справочники.ВидыДокументовВводДанныхДляРасчетаЗарплаты);
	ПравоДоступаТарифныеГруппы              = ПравоДоступа("Просмотр", Метаданные.Справочники.ТарифныеСетки);
	ПравоДоступаКвалификационныеРазряды     = ПравоДоступа("Просмотр", Метаданные.Справочники.РазрядыКатегорииДолжностей);
	
	//Права просмотра Льгот НДФЛ.
	ПравоДоступаВидыДоходовНДФЛ               = ПравоДоступа("Просмотр", Метаданные.Справочники.ВидыДоходовНДФЛ);
	ПравоДоступаВидыЛьготПоНДФЛ             = ПравоДоступа("Просмотр", Метаданные.Справочники.ВидыЛьготПоНДФЛ);
	ПравоДоступаРазмерЛьготНДФЛ             = ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.РазмерыЛьготНДФЛ);
	
	//Права просмотра настроек по страховым взносам.
	ПравоДоступаШкалаСтавокНалогов        = ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ШкалаСтавокНалогов);
	ПравоДоступаКатегорииЗастрахованныхЛицЕСВ = ПравоДоступа("Просмотр", Метаданные.Справочники.КатегорииЗастрахованныхЛицЕСВ);
	ПравоДоступаНалоги			         = ПравоДоступа("Просмотр", Метаданные.Справочники.Налоги);
	ПравоДоступаПараметрыКатегорийЕСВ	 = ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ПараметрыКатегорийЕСВ);
	
	//Управление видимостью нормативно-справочной информации.
	Элементы.КнопкаПодразделенияОрганизаций.Видимость    = ПравоДоступаПодразделения;
	
	Элементы.КнопкаДолжности.Видимость    = ПравоДоступаДолжности;
	Элементы.ДекорацияДолжности.Видимость = ПравоДоступаДолжности;
	
	Элементы.ОткрытьМестаРаботы.Видимость = ПравоДоступаМестаРаботы И ПолучитьФункциональнуюОпцию("ИспользоватьКраткосрочныеИзмененияОплатыТрудаВЗависимостиОтВыполняемойРаботы");
	
	Элементы.КнопкаВидыИспользованияРабочегоВремени.Видимость    = ПравоДоступаВидыИспользованияРабочегоВремени;
	Элементы.ДекорацияВидыИспользованияРабочегоВремени.Видимость = ПравоДоступаВидыИспользованияРабочегоВремени;
	
	Элементы.КнопкаГрафикиРаботыСотрудников.Видимость    = ПравоДоступаГрафикиРаботыСотрудников;
	Элементы.ДекорацияГрафикиРаботыСотрудников.Видимость = ПравоДоступаГрафикиРаботыСотрудников;
	
	Элементы.КнопкаВидыРаботСотрудников.Видимость    = ПравоДоступаВидыРаботСотрудников;
	Элементы.ДекорацияВидыРаботСотрудников.Видимость = ПравоДоступаВидыРаботСотрудников;
	
	Элементы.ГруппаЗарплатныеПроекты.Видимость = ПравоДоступаЗарплатныеПроекты;
	Элементы.ОткрытьСпособыВыплатыЗарплаты.Видимость = ПравоДоступаСпособыВыплаты;
	Элементы.ОткрытьСпособыОкругления.Видимость = ПравоДоступаСпособыОкругления;
	
	//Управление видимостью данных для расчета.
	Элементы.КнопкаПВРНачисления.Видимость    = ПравоДоступаНачисления;
	Элементы.ДекорацияПВРНачисления.Видимость = ПравоДоступаНачисления;
	Элементы.КнопкаПВРУдержания.Видимость     = ПравоДоступаУдержания;
	Элементы.ПВРУдержания.Видимость           = ПравоДоступаУдержания;
	
	Элементы.КнопкаПоказателиРасчетаЗарплаты.Видимость    = ПравоДоступаПоказателиРасчетаЗарплаты;
	Элементы.ДекорацияПоказателиРасчетаЗарплаты.Видимость = ПравоДоступаПоказателиРасчетаЗарплаты;
	
	Элементы.КнопкаВидыДокументовВводДанныхДляРасчетаЗарплаты.Видимость		= ПравоДоступаВидыДокументовВводДанныхДляРасчетаЗарплаты;
	Элементы.ДекорацияВидыДокументовВводДанныхДляРасчетаЗарплаты.Видимость	= ПравоДоступаВидыДокументовВводДанныхДляРасчетаЗарплаты;
	
	Элементы.ОткрытьТарифныеСетки.Видимость = ПравоДоступаТарифныеГруппы И ПолучитьФункциональнуюОпцию("ИспользоватьТарифныеСеткиПриРасчетеЗарплатыХозрасчет");
	Элементы.ОткрытьКвалификационныеРазряды.Видимость = ПравоДоступаКвалификационныеРазряды И ПолучитьФункциональнуюОпцию("ИспользоватьТарифныеСеткиПриРасчетеЗарплатыХозрасчет");
		
	//Управление видимостью данных для расчета НДФЛ.
	Элементы.КнопкаВидыДоходовНДФЛ.Видимость    = ПравоДоступаВидыДоходовНДФЛ;
	Элементы.ДекорацияВидыДоходовНДФЛ.Видимость = ПравоДоступаВидыДоходовНДФЛ;
	
	
	Элементы.КнопкаВидыЛьготПоНДФЛ.Видимость    = ПравоДоступаВидыЛьготПоНДФЛ;
	Элементы.ДекорацияВидыЛьготПоНДФЛ.Видимость = ПравоДоступаВидыЛьготПоНДФЛ;
	
	Элементы.КнопкаРазмерЛьготНДФЛ.Видимость    = ПравоДоступаРазмерЛьготНДФЛ;
	Элементы.ДекорацияРазмерЛьготНДФЛ.Видимость = ПравоДоступаРазмерЛьготНДФЛ;
	
	//Управление видимостью настроек страховых взносов.
	Элементы.КнопкаКатегорииЗастрахованныхЛиц.Видимость  = ПравоДоступаКатегорииЗастрахованныхЛицЕСВ;
	Элементы.ДекорацияКатегорииЗастрахованныхЛиц.Видимость = ПравоДоступаКатегорииЗастрахованныхЛицЕСВ;
	Элементы.КнопкаНалоги.Видимость  = ПравоДоступаНалоги;
	Элементы.ДекорацияНалоги.Видимость = ПравоДоступаНалоги;
	Элементы.КнопкаПараметрыКатегорийЕСВ.Видимость  = ПравоДоступаПараметрыКатегорийЕСВ;
	Элементы.ДекорацияПараметрыКатегорийЕСВ.Видимость = ПравоДоступаПараметрыКатегорийЕСВ;
	Элементы.КнопкаТарифыСтраховыхВзносов.Видимость  = ПравоДоступаШкалаСтавокНалогов;
	Элементы.ДекорацияТарифыСтраховыхВзносов.Видимость = ПравоДоступаШкалаСтавокНалогов;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТарифныеСетки(Команда)
	
	ПараметрыОткрытия = Новый Структура();
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ВидТарифнойСетки", ПредопределенноеЗначение("Перечисление.ВидыТарифныхСеток.Тариф"));
	ПараметрыОткрытия.Вставить("Отбор", СтруктураОтбора);
	
	ОткрытьФорму("Справочник.ТарифныеСетки.ФормаСписка", 
		ПараметрыОткрытия, 
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКвалификационныеРазряды(Команда)
	ОткрытьФорму("Справочник.РазрядыКатегорииДолжностей.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСпособыВыплатыЗарплаты(Команда)
	ОткрытьФорму("Справочник.СпособыВыплатыЗарплаты.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСпособыОкругления(Команда)
	ОткрытьФорму("Справочник.СпособыОкругленияПриРасчетеЗарплаты.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРегистрСведенийПараметрыКатегорийЕСВ(Команда)
	
	ОткрытьФорму("РегистрСведений.ПараметрыКатегорийЕСВ.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникНалоги(Команда)
	
	ОткрытьФорму("Справочник.Налоги.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
