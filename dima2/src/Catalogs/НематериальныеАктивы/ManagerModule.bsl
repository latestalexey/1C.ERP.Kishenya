#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Команда = Документы.ПринятиеКУчетуНМА.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.СписокФорм = "ФормаЭлемента, ФормаСпискаБУ";
	КонецЕсли;
	
	Команда = Документы.ИзменениеПараметровНМА.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.СписокФорм = "ФормаЭлемента, ФормаСпискаБУ";
	КонецЕсли;
	
	Команда = Документы.СписаниеНМА.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.СписокФорм = "ФормаЭлемента, ФормаСпискаБУ";
	КонецЕсли;
	
	//++ НЕ УТКА
	
	Команда = Документы.ПринятиеКУчетуНМАМеждународныйУчет.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.СписокФорм = "ФормаЭлемента, ФормаСпискаМФУ";
	КонецЕсли;
	
	Команда = Документы.ИзменениеПараметровНМАМеждународныйУчет.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.СписокФорм = "ФормаЭлемента, ФормаСпискаМФУ";
	КонецЕсли;
	
	Команда = Документы.СписаниеНМАМеждународныйУчет.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.СписокФорм = "ФормаЭлемента, ФормаСпискаМФУ";
	КонецЕсли;
	
	//-- НЕ УТКА
	
КонецПроцедуры

Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт
	
	//++ НЕ УТКА
	
	Команда = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуКарточкаНМАМеждународныйУчет(КомандыОтчетов);
	Если Команда <> Неопределено Тогда
		Команда.СписокФорм = "ФормаЭлемента, ФормаСпискаМФУ";
	КонецЕсли;
	
	Команда = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСравнениеНМА(КомандыОтчетов);
	Если Команда <> Неопределено Тогда
		Команда.СписокФорм = "ФормаЭлемента, ФормаСпискаМФУ";
	КонецЕсли;
	
	//-- НЕ УТКА
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Контекст")Тогда
		
		ИндексЗапятой = СтрНайти(Параметры.Контекст, ",");
		Контекст = Параметры.Контекст;
		Если ИндексЗапятой <> 0 Тогда
			Контекст = Сред(Контекст, 1, ИндексЗапятой-1);
		КонецЕсли;
		
		Если Контекст = "БУ"
			И (ОбщегоНазначенияУТКлиентСервер.СтруктураСодержитКлючи(Параметры, "ТекущийРегистратор, ДатаСведений")
				Или Параметры.Свойство("Отбор")
				И ОбщегоНазначенияУТКлиентСервер.СтруктураСодержитКлючи(Параметры.Отбор, "БУОрганизация, БУСостояние")) Тогда
			
			Параметры.Отбор.Вставить("Ссылка", ВнеоборотныеАктивыВызовСервера.ЭлементыНМАПоОтборуБУ(Параметры));
		//++ НЕ УТКА
		ИначеЕсли Контекст = "МФУ"
			И (ОбщегоНазначенияУТКлиентСервер.СтруктураСодержитКлючи(Параметры, "ТекущийРегистратор, ДатаСведений")
				Или Параметры.Свойство("Отбор")
				И ОбщегоНазначенияУТКлиентСервер.СтруктураСодержитКлючи(Параметры.Отбор, "МФУСостояние, МФУОрганизация, МФУПодразделение")) Тогда
			
			Параметры.Отбор.Вставить("Ссылка", ВнеоборотныеАктивыВызовСервера.ЭлементыНМАПоОтборуМФУ(Параметры));
		//-- НЕ УТКА
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли