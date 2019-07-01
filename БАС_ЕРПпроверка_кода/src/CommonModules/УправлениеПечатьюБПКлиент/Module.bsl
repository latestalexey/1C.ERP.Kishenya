
#Область СлужебныйПрограммныйИнтерфейс

Функция ВыполнитьКомандуПечати(ОписаниеКоманды) Экспорт
	ПараметрыПечати = ПолучитьЗаголовокПечатнойФормы(ОписаниеКоманды.ОбъектыПечати);
	
	Если ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда
		ПараметрыПечати.Вставить("ДополнительныеПараметры", ОписаниеКоманды.ДополнительныеПараметры);
	КонецЕсли; 
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(ОписаниеКоманды.МенеджерПечати, ОписаниеКоманды.Идентификатор, ОписаниеКоманды.ОбъектыПечати,
		ОписаниеКоманды.Форма, ПараметрыПечати);
	
КонецФункции

Функция ВыполнитьКомандуПечатиСписка(ОписаниеКоманды) Экспорт

	ПараметрыПечати = Новый Структура;
	Если ОписаниеКоманды.Свойство("ЗаголовокФормы") Тогда
		ПараметрыПечати.Вставить("ЗаголовокФормы", ОписаниеКоманды.ЗаголовокФормы);
	КонецЕсли;
	
	Если ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда
		ПараметрыПечати.Вставить("ДополнительныеПараметры", ОписаниеКоманды.ДополнительныеПараметры);
	КонецЕсли; 
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(ОписаниеКоманды.МенеджерПечати, ОписаниеКоманды.Идентификатор, ОписаниеКоманды.ОбъектыПечати,
		ОписаниеКоманды.Форма, ПараметрыПечати);
	
КонецФункции

Функция ВыполнитьКомандуПечатиКарточкиОС(ОписаниеКоманды) Экспорт
	
	ПараметрыПечати = ПолучитьЗаголовокПечатнойФормы(ОписаниеКоманды.ОбъектыПечати);
	Если ОписаниеКоманды.Свойство("ДатаСведений") Тогда
		ПараметрыПечати.Вставить("ДатаСведений", ОписаниеКоманды.ДатаСведений);
	КонецЕсли;
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(ОписаниеКоманды.МенеджерПечати, ОписаниеКоманды.Идентификатор, ОписаниеКоманды.ОбъектыПечати,
		ОписаниеКоманды.Форма, ПараметрыПечати);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры для команд печати
Функция ПолучитьЗаголовокПечатнойФормы(ПараметрКоманды) Экспорт 
	
	Если Тип(ПараметрКоманды) = Тип("Массив") И ПараметрКоманды.Количество() = 1 Тогда 
		Возврат Новый Структура("ЗаголовокФормы", ПараметрКоманды[0]);
	Иначе
		Возврат Новый Структура;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ЭДО

Функция ОткрытьПечатнуюФормуПредварительногоПросмотраЭДО(ОписаниеКоманды) Экспорт
	
	Результат = Истина;
	
	МассивОбъектов = ОписаниеКоманды.ОбъектыПечати;
	
	Если МассивОбъектов.Количество() = 0  Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если Не РегламентированнаяОтчетностьКлиент.ПодключитьМенеджерЗвит1С() Тогда
		Возврат Результат;
	КонецЕсли;
	
	ИмяОтчета 		= "РегламентированныйОтчетПервичныеДокументыЗвит1С";
	ЭтоВнешнийОтчет = РегламентированнаяОтчетность.ЭтоВнешнийОтчет(ИмяОтчета);
	
	Для каждого Ссылка Из МассивОбъектов Цикл	
		
		ИмяФормыПросмотра = глМенеджерЗвит1С.ОпределитьИмяФормыВыгрузки(Ссылка);
		
		// откроем отчет и загрузим в него данные XML
		Попытка
			ФормаПросмотра = ПолучитьФорму(?(ЭтоВнешнийОтчет, "Внешний", "") + "Отчет." + ИмяОтчета + ".Форма." + ИмяФормыПросмотра);
		Исключение
			ТекстОшибки = НСтр("ru='Не удалось открыть для просмотра требуемую форму отчета ';uk='Не вдалося відкрити для перегляду необхідну форму звіту '")+ИмяОтчета;
			ПоказатьПредупреждение(,ТекстОшибки);
			Возврат Результат;	
		КонецПопытки;
		
		ТабДокумент = ФормаПросмотра.ЗаполнитьИРаспечатать(Ссылка);
		ТабДокумент.Защита 			= Истина;
		ТабДокумент.ТолькоПросмотр 	= Ложь;
		ТабДокумент.ОтображатьСетку 	 = Ложь;
		ТабДокумент.ОтображатьЗаголовки  = Ложь;
		ТабДокумент.Показать("" + Ссылка + НСтр("ru=' (для выгрузки в FREDO ДокМен)';uk= ' (для вивантаження до FREDO ДокМен)'"));
		
	КонецЦикла;
	
КонецФункции

#КонецОбласти
