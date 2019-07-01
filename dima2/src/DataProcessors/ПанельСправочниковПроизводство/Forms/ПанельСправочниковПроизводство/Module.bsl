
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеЭлементами();
	
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

&НаКлиенте
Процедура ОткрытьСтруктуруПредприятия(Команда)
	
	ПараметрыФормы = Новый Структура("ТолькоПроизводственныеПодразделения", Истина);
	ОткрытьФорму("Справочник.СтруктураПредприятия.ФормаСписка", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКалендари(Команда)
	
	ОткрытьФорму("Справочник.Календари.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПриоритетыЗаказов(Команда)
	
	ОткрытьФорму("Справочник.Приоритеты.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОчередьПроизводственныхПодразделений(Команда)
	
	ОткрытьФорму("Справочник.СтруктураПредприятия.Форма.НастройкаПриоритетовПроизводственныхПодразделений", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПричиныЗадержкиВыполненияМаршрутныхЛистов(Команда)
	
	//++ НЕ УТКА
	ОткрытьФорму("Справочник.ПричиныЗадержкиВыполненияМаршрутныхЛистов.ФормаСписка", , ЭтаФорма);
	//-- НЕ УТКА
	Возврат; // в КА2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПараметрыМежоперационныхПереходов(Команда)
	
	//++ НЕ УТКА
	ОткрытьФорму("РегистрСведений.ПараметрыМежоперационныхПереходов.ФормаСписка", , ЭтаФорма);
	//-- НЕ УТКА
	Возврат; // в КА2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМоделиПооперационногоПланирования(Команда)
	
	//++ НЕ УТКА
	ОткрытьФорму("Справочник.МоделиПооперационногоПланирования.ФормаСписка", , ЭтаФорма);
	//-- НЕ УТКА
	Возврат; // в КА2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСценарииПооперационногоПланирования(Команда)
	
	//++ НЕ УТКА
	ОткрытьФорму("Справочник.СценарииПооперационногоПланирования.ФормаСписка", , ЭтаФорма);
	//-- НЕ УТКА
	Возврат; // в КА2 не используется
	
КонецПроцедуры

#Область Ремонты

&НаКлиенте
Процедура ОткрытьКлассыОбъектовЭксплуатации(Команда)
	
	//++ НЕ УТКА
	ОткрытьФорму("Справочник.КлассыОбъектовЭксплуатации.ФормаСписка", , ЭтаФорма);
	//-- НЕ УТКА
	Возврат; // в КА2 не используется

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбщиеВидыРемонтов(Команда)
	
	//++ НЕ УТКА
	ОткрытьФорму("Справочник.ОбщиеВидыРемонтов.ФормаСписка", , ЭтаФорма);
	//-- НЕ УТКА
	Возврат; // в КА2 не используется

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыДефектов(Команда)
	
	//++ НЕ УТКА
	ОткрытьФорму("Справочник.ВидыДефектов.ФормаСписка", , ЭтаФорма);
	//-- НЕ УТКА
	Возврат; // в КА2 не используется
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПоказателиНаработки(Команда)
	
	//++ НЕ УТКА
	ОткрытьФорму("Справочник.ПоказателиНаработки.ФормаСписка", , ЭтаФорма);
	//-- НЕ УТКА
	Возврат; // в КА2 не используется
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеЭлементами()
	
	УправлениеПредприятием = ПолучитьФункциональнуюОпцию("УправлениеПредприятием");
	
	#Область ПроизводственнаяСтруктура
	ПравоДоступаПодразделения  = ПравоДоступа("Просмотр", Метаданные.Справочники.СтруктураПредприятия);
	ПравоДоступаРабочиеЦентры  = Ложь;
	//++ НЕ УТКА
	ПравоДоступаРабочиеЦентры  = ПравоДоступа("Просмотр", Метаданные.Справочники.РабочиеЦентры);
	//-- НЕ УТКА
	ПравоДоступаКалендари      = ПравоДоступа("Просмотр", Метаданные.Справочники.Календари);
	
	Элементы.ГруппаСтруктураПредприятия.Видимость    = ПравоДоступаПодразделения;
	Элементы.ГруппаСтруктураРабочихЦентров.Видимость = ПравоДоступаРабочиеЦентры И УправлениеПредприятием;
	Элементы.ГруппаКалендари.Видимость               = ПравоДоступаКалендари;
	
	// Заголовок группы
	Элементы.ГруппаПроизводственнаяСтруктура.Видимость =
		Элементы.ГруппаСтруктураПредприятия.Видимость
		ИЛИ Элементы.ГруппаСтруктураРабочихЦентров.Видимость
		ИЛИ Элементы.ГруппаКалендари.Видимость;
	#КонецОбласти
	
	#Область МежцеховоеУправление
	ПравоДоступаПриоритеты = ПравоДоступа("Просмотр", Метаданные.Справочники.Приоритеты); 
	ПравоДоступаНастройкаОчередиПроизводственныхПодразделений = ПравоДоступа("Просмотр", Метаданные.Справочники.СтруктураПредприятия);
	
	Элементы.ОткрытьПриоритетыЗаказов.Видимость = ПравоДоступаПриоритеты И УправлениеПредприятием; 
	Элементы.ОткрытьНастройкуОчередиПроизводственныхПодразделений.Видимость = ПравоДоступаНастройкаОчередиПроизводственныхПодразделений И УправлениеПредприятием;
	
	Элементы.ГруппаМежцеховоеУправление.Видимость =
		Элементы.ОткрытьПриоритетыЗаказов.Видимость
		ИЛИ Элементы.ОткрытьНастройкуОчередиПроизводственныхПодразделений.Видимость;
	#КонецОбласти
	
	#Область ВнутрицеховоеУправление
	//++ НЕ УТКА
	ПравоПараметрыМежоперационныхПереходов = ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ПараметрыМежоперационныхПереходов);
	ПравоПричиныЗадержкиВыполненияМаршрутныхЛистов = ПравоДоступа("Просмотр", Метаданные.Справочники.ПричиныЗадержкиВыполненияМаршрутныхЛистов);
	ПравоМоделиПооперационногоПланирования = ПравоДоступа("Просмотр", Метаданные.Справочники.МоделиПооперационногоПланирования);
	ПравоСценарииПооперационногоПланирования = ПравоДоступа("Просмотр", Метаданные.Справочники.СценарииПооперационногоПланирования);
	
	Элементы.ГруппаПричиныЗадержкиПроизводства.Видимость = ПравоПричиныЗадержкиВыполненияМаршрутныхЛистов;
	Элементы.ГруппаПараметрыМежоперационныхПереходов.Видимость = ПравоПараметрыМежоперационныхПереходов;
	Элементы.ГруппаМоделиПооперационногоПланирования.Видимость = ПравоМоделиПооперационногоПланирования;
	Элементы.ГруппаСценарииПооперационногоПланирования.Видимость = ПравоСценарииПооперационногоПланирования;
	//-- НЕ УТКА
	
	// Заголовок группы
	Элементы.ГруппаВнутрицеховоеУправление.Видимость = 
	    УправлениеПредприятием
		//++ НЕ УТКА
		И (ПравоПричиныЗадержкиВыполненияМаршрутныхЛистов 
			Или ПравоПараметрыМежоперационныхПереходов 
			Или ПравоМоделиПооперационногоПланирования
			Или ПравоСценарииПооперационногоПланирования)
		//-- НЕ УТКА
			;
	#КонецОбласти
	
	//++ НЕ УТКА
	#Область Ремонты
	Элементы.ОткрытьКлассыОбъектовЭксплуатации.Видимость 
		= ПравоДоступа("Просмотр", Метаданные.Справочники.КлассыОбъектовЭксплуатации);
	Элементы.ОткрытьОбщиеВидыРемонтов.Видимость 
		= ПравоДоступа("Просмотр", Метаданные.Справочники.ОбщиеВидыРемонтов);
	Элементы.ОткрытьВидыДефектов.Видимость
		= ПравоДоступа("Просмотр", Метаданные.Справочники.ВидыДефектов);
	Элементы.ОткрытьПоказателиНаработки.Видимость
		= ПравоДоступа("Просмотр", Метаданные.Справочники.ПоказателиНаработки);
	#КонецОбласти
	//-- НЕ УТКА
	
КонецПроцедуры

#КонецОбласти
