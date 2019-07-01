#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ИнициализироватьОтчет();

	СтандартнаяОбработка = Ложь;
	
	НастройкиОтчета = ЭтотОбъект.КомпоновщикНастроек.ПолучитьНастройки();				   

	ДокументРезультат.Очистить();
	
	КлючВарианта = ЗарплатаКадрыОтчеты.КлючВарианта(КомпоновщикНастроек);
	
	Если КлючВарианта = Неопределено Тогда 
		КлючВарианта = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.КлючВарианта;
	КонецЕсли;
	
	Если КлючВарианта = "ЮридическаяСтруктура" Тогда
		
		// Параметры документа
		ДокументРезультат.ТолькоПросмотр = Истина;
		ДокументРезультат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОрганизационнаяСтруктура";
		ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		
		ДатаОтчета = '00010101';
		
		УстановитьДатуОтчета(НастройкиОтчета, ДатаОтчета);
		
		ПараметрЮридическаяСтруктура = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ЮридическаяСтруктура"));	
		Если ПараметрЮридическаяСтруктура <> Неопределено Тогда
			ПараметрЮридическаяСтруктура.Значение = Истина;
		КонецЕсли;
		
		ДанныеОтчета = Новый ДеревоЗначений;
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
		// Создадим и инициализируем процессор компоновки.
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
		
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ПроцессорВывода.УстановитьОбъект(ДанныеОтчета);
		
		// Обозначим начало вывода
		ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
		
		ВывестиМакетЮридическаяСтруктура(ДокументРезультат, ДанныеОтчета, ДатаОтчета);
		
	ИначеЕсли КлючВарианта = "УправленческаяСтруктура" Тогда
		
		// Параметры документа
		ДокументРезультат.ТолькоПросмотр = Истина;
		ДокументРезультат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОрганизационнаяСтруктура";
		ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		
		ДатаОтчета = '00010101';
		
		УстановитьДатуОтчета(НастройкиОтчета, ДатаОтчета);
		
		ПараметрЮридическаяСтруктура = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ЮридическаяСтруктура"));	
		Если ПараметрЮридическаяСтруктура <> Неопределено Тогда
			ПараметрЮридическаяСтруктура.Значение = Ложь;
		КонецЕсли;
		
		ДанныеОтчета = Новый ДеревоЗначений;
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
		// Создадим и инициализируем процессор компоновки.
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
		
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ПроцессорВывода.УстановитьОбъект(ДанныеОтчета);
		
		// Обозначим начало вывода
		ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
		
		ВывестиМакетУправленческаяСтруктура(ДокументРезультат, ДанныеОтчета, ДатаОтчета);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект);
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ИнициализироватьОтчет();
	ЗначениеВДанныеФормы(ЭтотОбъект, Форма.Отчет);
	
КонецПроцедуры

Процедура ВывестиМакетЮридическаяСтруктура(ДокументРезультат, ДанныеОтчета, ДатаОтчета)
	
	ДополнительныеПараметры = ПараметрыОтчета(ДанныеОтчета, ДатаОтчета);
	
	ПараметрыМакета = ДополнительныеПараметры.ПараметрыМакета;
	
	ОбластьПодразделение 	= ПараметрыМакета.ОбластьПодразделение;
	ОбластьДанныеПозиции 	= ПараметрыМакета.ОбластьДанныеПозиции;
	ОбластьСотрудник 		= ПараметрыМакета.ОбластьСотрудник;
	ОбластьЧертаСлева 		= ПараметрыМакета.ОбластьЧертаСлева;
	ОбластьЧертаСнизу 		= ПараметрыМакета.ОбластьЧертаСнизу;
	ОбластьУгол 			= ПараметрыМакета.ОбластьУгол;
	ОбластьПустойБлок 		= ПараметрыМакета.ОбластьПустойБлок;
	
	Для Каждого ДанныеОрганизации Из ДанныеОтчета.Строки Цикл 
		
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ВывестиДанныеПодразделенияВерхнегоУровня(ТабличныйДокумент, ДанныеОрганизации, ДанныеОрганизации.Организация, ДополнительныеПараметры);
		
		ДокументРезультат.Вывести(ОбластьПустойБлок);
		ДокументРезультат.Вывести(ОбластьПустойБлок);
		
		ОбластьПодразделение.Параметры.ПодразделениеНаименование = ДанныеОрганизации.ОрганизацияНаименование;
		ОбластьПодразделение.Параметры.Подразделение = ДанныеОрганизации.Организация;
		ДокументРезультат.Присоединить(ОбластьПодразделение);
		
		ОбластьЯчеек = ДокументРезультат.Вывести(ТабличныйДокумент.ПолучитьОбласть(1, 1, ТабличныйДокумент.ВысотаТаблицы, ТабличныйДокумент.ШиринаТаблицы));
		ОбластьЯчеек.ШиринаКолонки = 6;
		
		ДокументРезультат.Вывести(ОбластьПустойБлок);
		
		ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВывестиМакетУправленческаяСтруктура(ДокументРезультат, ДанныеОтчета, ДатаОтчета)
	
	ДополнительныеПараметры = ПараметрыОтчета(ДанныеОтчета, ДатаОтчета);
	
	ПараметрыМакета = ДополнительныеПараметры.ПараметрыМакета;
	
	ОбластьПодразделение 	= ПараметрыМакета.ОбластьПодразделение;
	ОбластьДанныеПозиции 	= ПараметрыМакета.ОбластьДанныеПозиции;
	ОбластьСотрудник 		= ПараметрыМакета.ОбластьСотрудник;
	ОбластьЧертаСлева 		= ПараметрыМакета.ОбластьЧертаСлева;
	ОбластьЧертаСнизу 		= ПараметрыМакета.ОбластьЧертаСнизу;
	ОбластьУгол 			= ПараметрыМакета.ОбластьУгол;
	ОбластьПустойБлок 		= ПараметрыМакета.ОбластьПустойБлок;
	
	Для Каждого ДанныеПодразделения Из ДанныеОтчета.Строки Цикл 
		
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ВывестиДанныеПодразделенияВерхнегоУровня(ТабличныйДокумент, ДанныеПодразделения, ДанныеПодразделения.Подразделение, ДополнительныеПараметры);
		
		ДокументРезультат.Вывести(ОбластьПустойБлок);
		ДокументРезультат.Вывести(ОбластьПустойБлок);
		
		ОбластьПодразделение.Параметры.ПодразделениеНаименование = ДанныеПодразделения.ПодразделениеНаименование;
		ОбластьПодразделение.Параметры.Подразделение = ДанныеПодразделения.Подразделение;
		ДокументРезультат.Присоединить(ОбластьПодразделение);
		
		ОбластьЯчеек = ДокументРезультат.Вывести(ТабличныйДокумент.ПолучитьОбласть(1, 1, ТабличныйДокумент.ВысотаТаблицы, ТабличныйДокумент.ШиринаТаблицы));
		ОбластьЯчеек.ШиринаКолонки = 6;
		
		ДокументРезультат.Вывести(ОбластьПустойБлок);
		
		ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВывестиДанныеПодразделенияВерхнегоУровня(ДокументРезультат, ДанныеОрганизации, ТекущееПодразделение, ДополнительныеПараметры)
	
	ПараметрыМакета = ДополнительныеПараметры.ПараметрыМакета;
	НастройкиОтчета = ДополнительныеПараметры.НастройкиОтчета;
	РуководителиПодразделений = ДополнительныеПараметры.РуководителиПодразделений;
	
	ОбластьПодразделение 				= ПараметрыМакета.ОбластьПодразделение;
	ОбластьРуководительПодразделения 	= ПараметрыМакета.ОбластьРуководительПодразделения;
	ОбластьЧертаСлева 					= ПараметрыМакета.ОбластьЧертаСлева;
	ОбластьЧертаСнизу 					= ПараметрыМакета.ОбластьЧертаСнизу;
	ОбластьУгол 						= ПараметрыМакета.ОбластьУгол;
	ОбластьПустойБлок 					= ПараметрыМакета.ОбластьПустойБлок;
	
	ВыводитьРуководителей = НастройкиОтчета.ВыводитьРуководителей;
	
	КоличествоПодразделений = 0;
	Для Каждого ДанныеПодразделенияВерхнегоУровня Из ДанныеОрганизации.Строки Цикл 
		Если ДанныеПодразделенияВерхнегоУровня.Подразделение <> ТекущееПодразделение Тогда 
			КоличествоПодразделений = КоличествоПодразделений + 1;
		КонецЕсли;
	КонецЦикла;
	
	НомерПодразделения = 1;
	
	Для Каждого ДанныеПодразделенияВерхнегоУровня Из ДанныеОрганизации.Строки Цикл 
		
		Если ДанныеПодразделенияВерхнегоУровня.Подразделение = ТекущееПодразделение Тогда 
			Продолжить;
		КонецЕсли;
		
		МаксимальныйИндекс = 0;
		ЕстьПодчиненныеПодразделения = Ложь;
		
		Для Каждого ДанныеПодразделения Из ДанныеПодразделенияВерхнегоУровня.Строки Цикл 
			Если ДанныеПодразделения.Подразделение <> ДанныеПодразделенияВерхнегоУровня.Подразделение Тогда 
				МаксимальныйИндекс = ДанныеПодразделенияВерхнегоУровня.Строки.Индекс(ДанныеПодразделения);
				ЕстьПодчиненныеПодразделения = Истина;
			КонецЕсли;
		КонецЦикла;
		
		СписокПозиций = Новый Массив;
		ЗаполнитьСписокПозицийПодразделения(ДанныеПодразделенияВерхнегоУровня, ДанныеПодразделенияВерхнегоУровня.Подразделение, СписокПозиций);
		
		ОбластьПодчиненныеПозиции = Новый ТабличныйДокумент;
		ВывестиДанныеПозиций(ОбластьПодчиненныеПозиции, СписокПозиций, Не ЕстьПодчиненныеПодразделения, ДополнительныеПараметры);
		
		ОбластьПодчиненныеПодразделения = Новый ТабличныйДокумент;
		ТабличныйДокумент = Новый ТабличныйДокумент;
		
		Для Каждого ДанныеПодразделения Из ДанныеПодразделенияВерхнегоУровня.Строки Цикл 
			
			Если ДанныеПодразделения.Подразделение = ДанныеПодразделенияВерхнегоУровня.Подразделение Тогда 
				Продолжить;
			КонецЕсли;
			
			ТабличныйДокумент = Новый ТабличныйДокумент;
			ВывестиДанныеПодразделения(ТабличныйДокумент, ДанныеПодразделения, ДанныеПодразделения.Подразделение, ДополнительныеПараметры);
			
			Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
				
				ЛеваяКолонка = Новый ТабличныйДокумент;
				ЛеваяКолонка.Вывести(ОбластьЧертаСлева);
				ЛеваяКолонка.Вывести(ОбластьУгол);
				
				Если ДанныеПодразделенияВерхнегоУровня.Строки.Индекс(ДанныеПодразделения) < МаксимальныйИндекс Тогда 
					КоличествоСтрок = ТабличныйДокумент.ВысотаТаблицы - 2;
					Для Сч = 1 По КоличествоСтрок Цикл 
						ЛеваяКолонка.Вывести(ОбластьЧертаСлева);
					КонецЦикла;
				КонецЕсли;
				
				ОбластьПодчиненныеПодразделения.Вывести(ЛеваяКолонка.ПолучитьОбласть(1, 1, ЛеваяКолонка.ВысотаТаблицы, 1));
				ОбластьПодчиненныеПодразделения.Присоединить(ТабличныйДокумент.ПолучитьОбласть(1, 1, ТабличныйДокумент.ВысотаТаблицы, ТабличныйДокумент.ШиринаТаблицы));
				
			КонецЕсли;	
			
		КонецЦикла;
		
		ОбластьПодразделениеВерхнегоУровня = Новый ТабличныйДокумент;
		
		ВыводимаяОбласть = ?(НомерПодразделения = 1, ОбластьПустойБлок, ОбластьЧертаСнизу);
		ОбластьПодразделениеВерхнегоУровня.Вывести(ВыводимаяОбласть);
		Для Сч = 1 По 3 Цикл 
			ОбластьПодразделениеВерхнегоУровня.Присоединить(ВыводимаяОбласть);
		КонецЦикла;	
		
		Если КоличествоПодразделений > 1 Тогда
			Если НомерПодразделения <> КоличествоПодразделений Тогда
				ОбластьПодразделениеВерхнегоУровня.Присоединить(?(НомерПодразделения = 1, ОбластьУгол, ОбластьЧертаСнизу));
				ШиринаТаблицы = Макс(ОбластьПодчиненныеПодразделения.ШиринаТаблицы, ОбластьПодчиненныеПозиции.ШиринаТаблицы, ОбластьПодразделение.ШиринаТаблицы, 5);
				Для Сч = 4 По ШиринаТаблицы Цикл 
					ОбластьПодразделениеВерхнегоУровня.Присоединить(ОбластьЧертаСнизу);
				КонецЦикла;
			КонецЕсли;
		Иначе 
			ОбластьПодразделениеВерхнегоУровня.Присоединить(ОбластьЧертаСлева);
		КонецЕсли;
		
		ОбластьПодразделениеВерхнегоУровня.Вывести(ОбластьПустойБлок);
		Для Сч = 1 По 3 Цикл 
			ОбластьПодразделениеВерхнегоУровня.Присоединить(ОбластьПустойБлок);
		КонецЦикла;	
		ОбластьПодразделениеВерхнегоУровня.Присоединить(ОбластьЧертаСлева);
		
		ОбластьПустаяКолонка = Новый ТабличныйДокумент;
		Для Сч = 1 По ОбластьПодчиненныеПодразделения.ВысотаТаблицы + 2 Цикл 
			ОбластьПустаяКолонка.Вывести(ОбластьПустойБлок);
		КонецЦикла;
		ОбластьПодразделениеВерхнегоУровня.Вывести(ОбластьПустаяКолонка.ПолучитьОбласть(1, 1, ОбластьПустаяКолонка.ВысотаТаблицы, 1));
		
		ОбластьДанныеПодразделения = Новый ТабличныйДокумент;
		ОбластьПодразделение.Параметры.ПодразделениеНаименование = ДанныеПодразделенияВерхнегоУровня.ПодразделениеНаименование;
		ОбластьПодразделение.Параметры.Подразделение = ДанныеПодразделенияВерхнегоУровня.Подразделение;
		ОбластьДанныеПодразделения.Вывести(ОбластьПодразделение);
		
		Если ВыводитьРуководителей Тогда
			ДанныеРуководителя = РуководителиПодразделений[ДанныеПодразделенияВерхнегоУровня.Подразделение];
			Если ДанныеРуководителя <> Неопределено Тогда 
				ОбластьДанныеПодразделения.Вывести(ОбластьРуководительПодразделения);
			КонецЕсли;
		КонецЕсли;
		
		Если ОбластьПодчиненныеПозиции.ВысотаТаблицы > 0 Тогда 
			ОбластьДанныеПодразделения.Вывести(ОбластьПодчиненныеПозиции.ПолучитьОбласть(1, 1, ОбластьПодчиненныеПозиции.ВысотаТаблицы, ОбластьПодчиненныеПозиции.ШиринаТаблицы));
		КонецЕсли;
		
		Если ОбластьПодчиненныеПодразделения.ВысотаТаблицы > 0 Тогда 
			ОбластьДанныеПодразделения.Вывести(ОбластьПодчиненныеПодразделения.ПолучитьОбласть(1, 1, ОбластьПодчиненныеПодразделения.ВысотаТаблицы, ОбластьПодчиненныеПодразделения.ШиринаТаблицы));
		КонецЕсли;
		
		ОбластьПодразделениеВерхнегоУровня.Присоединить(ОбластьДанныеПодразделения.ПолучитьОбласть(1, 1, ОбластьДанныеПодразделения.ВысотаТаблицы, ОбластьДанныеПодразделения.ШиринаТаблицы));
		
		ВысотаОбласти = ОбластьПодразделениеВерхнегоУровня.ВысотаТаблицы;
		ШиринаОбласти = ОбластьПодразделениеВерхнегоУровня.ШиринаТаблицы;
		
		Если НомерПодразделения = 1 Тогда
			ДокументРезультат.Вывести(ОбластьПодразделениеВерхнегоУровня.ПолучитьОбласть(1, 1, ВысотаОбласти, ШиринаОбласти));
		Иначе 
			ДокументРезультат.Присоединить(ОбластьПодразделениеВерхнегоУровня.ПолучитьОбласть(1, 1, ВысотаОбласти, ШиринаОбласти));
		КонецЕсли;
		
		НомерПодразделения = НомерПодразделения + 1;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВывестиДанныеПодразделения(ДокументРезультат, ДанныеВышестоящегоПодразделения, ТекущееПодразделение, ДополнительныеПараметры)
	
	ПараметрыМакета = ДополнительныеПараметры.ПараметрыМакета;
	НастройкиОтчета = ДополнительныеПараметры.НастройкиОтчета;
	РуководителиПодразделений = ДополнительныеПараметры.РуководителиПодразделений;
	
	ОбластьПодразделение 				= ПараметрыМакета.ОбластьПодразделение;
	ОбластьРуководительПодразделения 	= ПараметрыМакета.ОбластьРуководительПодразделения;
	ОбластьЧертаСлева 					= ПараметрыМакета.ОбластьЧертаСлева;
	ОбластьУгол 						= ПараметрыМакета.ОбластьУгол;
	ОбластьПустойБлок 					= ПараметрыМакета.ОбластьПустойБлок;
	
	ВыводитьРуководителей = НастройкиОтчета.ВыводитьРуководителей;
	
	ДокументРезультат.Вывести(ОбластьПустойБлок);
	
	ОбластьПодразделение.Параметры.ПодразделениеНаименование = ДанныеВышестоящегоПодразделения.ПодразделениеНаименование;
	ОбластьПодразделение.Параметры.Подразделение = ДанныеВышестоящегоПодразделения.Подразделение;
	ДокументРезультат.Вывести(ОбластьПодразделение);
	
	Если ВыводитьРуководителей Тогда
		ДанныеРуководителя = РуководителиПодразделений[ДанныеВышестоящегоПодразделения.Подразделение];
		Если ДанныеРуководителя <> Неопределено Тогда 
			ДокументРезультат.Вывести(ОбластьРуководительПодразделения);
		КонецЕсли;
	КонецЕсли;
	
	МаксимальныйИндекс = 0;
	ЕстьПодчиненныеПодразделения = Ложь;
	
	Для Каждого ДанныеПодразделения Из ДанныеВышестоящегоПодразделения.Строки Цикл 
		Если ДанныеПодразделения.Подразделение <> ТекущееПодразделение Тогда 
			МаксимальныйИндекс = ДанныеВышестоящегоПодразделения.Строки.Индекс(ДанныеПодразделения);
			ЕстьПодчиненныеПодразделения = Истина;
		КонецЕсли;
	КонецЦикла;
	
	СписокПозиций = Новый Массив;
	ЗаполнитьСписокПозицийПодразделения(ДанныеВышестоящегоПодразделения, ДанныеВышестоящегоПодразделения.Подразделение, СписокПозиций);
	
	ОбластьПодчиненныеПозиции = Новый ТабличныйДокумент;
	ВывестиДанныеПозиций(ОбластьПодчиненныеПозиции, СписокПозиций, Не ЕстьПодчиненныеПодразделения, ДополнительныеПараметры);
	
	Если ОбластьПодчиненныеПозиции.ВысотаТаблицы > 0 Тогда 
		ДокументРезультат.Вывести(ОбластьПодчиненныеПозиции.ПолучитьОбласть(1, 1, ОбластьПодчиненныеПозиции.ВысотаТаблицы, ОбластьПодчиненныеПозиции.ШиринаТаблицы));
	КонецЕсли;
	
	Для Каждого ДанныеПодразделения Из ДанныеВышестоящегоПодразделения.Строки Цикл 
		
		Если ДанныеПодразделения.Подразделение = ТекущееПодразделение Тогда 
			Продолжить;
		КонецЕсли;
		
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ВывестиДанныеПодразделения(ТабличныйДокумент, ДанныеПодразделения, ДанныеПодразделения.Подразделение, ДополнительныеПараметры);
		
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			
			ЛеваяКолонка = Новый ТабличныйДокумент;
			ЛеваяКолонка.Вывести(ОбластьЧертаСлева);
			ЛеваяКолонка.Вывести(ОбластьУгол);
			
			Если ДанныеВышестоящегоПодразделения.Строки.Индекс(ДанныеПодразделения) < МаксимальныйИндекс Тогда 
				КоличествоСтрок = ТабличныйДокумент.ВысотаТаблицы - 2;
				Для Сч = 1 По КоличествоСтрок Цикл 
					ЛеваяКолонка.Вывести(ОбластьЧертаСлева);
				КонецЦикла;
			КонецЕсли;
			
			ДокументРезультат.Вывести(ЛеваяКолонка.ПолучитьОбласть(1, 1, ЛеваяКолонка.ВысотаТаблицы, 1));
			ДокументРезультат.Присоединить(ТабличныйДокумент.ПолучитьОбласть(1, 1, ТабличныйДокумент.ВысотаТаблицы, ТабличныйДокумент.ШиринаТаблицы));
			
		КонецЕсли;	
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСписокПозицийПодразделения(ДанныеВышестоящегоПодразделения, Подразделение, СписокПозиций)
	
	Для Каждого ДанныеПодразделения Из ДанныеВышестоящегоПодразделения.Строки Цикл 
		
		Если ДанныеПодразделения.Подразделение <> Подразделение Тогда 
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДанныеПодразделения.Позиция) Тогда 
			Если Не ДанныеПодразделения.ПозицияЭтоГруппа Тогда
				СписокПозиций.Добавить(ДанныеПодразделения);
			КонецЕсли;
		Иначе 
			ЗаполнитьСписокПозицийПодразделения(ДанныеПодразделения, Подразделение, СписокПозиций);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВывестиДанныеПозиций(ДокументРезультат, СписокПозиций, ПоследнееПодразделение, ДополнительныеПараметры)
	
	ПараметрыМакета = ДополнительныеПараметры.ПараметрыМакета;
	
	ОбластьПодразделение 	= ПараметрыМакета.ОбластьПодразделение;
	ОбластьЧертаСлева 		= ПараметрыМакета.ОбластьЧертаСлева;
	ОбластьУгол 			= ПараметрыМакета.ОбластьУгол;
	ОбластьПустойБлок 		= ПараметрыМакета.ОбластьПустойБлок;
	
	МаксимальныйИндекс = СписокПозиций.Количество() - 1;
	
	Для ИндексЭлемента = 0 По МаксимальныйИндекс Цикл 
		
		ДанныеПозиции = СписокПозиций[ИндексЭлемента];
		
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ВывестиДанныеПозиции(ТабличныйДокумент, ДанныеПозиции, ДополнительныеПараметры);
		
		ЛеваяКолонка = Новый ТабличныйДокумент;
		ЛеваяКолонка.Вывести(ОбластьЧертаСлева);
		ЛеваяКолонка.Вывести(ОбластьУгол);
		
		Если Не ПоследнееПодразделение Или ИндексЭлемента < МаксимальныйИндекс Тогда 
			КоличествоСтрок = ТабличныйДокумент.ВысотаТаблицы - 2;
			Для Сч = 1 По КоличествоСтрок Цикл 
				ЛеваяКолонка.Вывести(ОбластьЧертаСлева);
			КонецЦикла;
		КонецЕсли;
		
		ДокументРезультат.Вывести(ЛеваяКолонка.ПолучитьОбласть(1, 1, ЛеваяКолонка.ВысотаТаблицы, 1));
		ДокументРезультат.Присоединить(ТабличныйДокумент.ПолучитьОбласть(1, 1, ТабличныйДокумент.ВысотаТаблицы, ТабличныйДокумент.ШиринаТаблицы));
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВывестиДанныеПозиции(ДокументРезультат, ДанныеПозиции, ДополнительныеПараметры)
	
	ПараметрыМакета = ДополнительныеПараметры.ПараметрыМакета;
	НастройкиОтчета = ДополнительныеПараметры.НастройкиОтчета;
	ФотографииСотрудников = ДополнительныеПараметры.ФотографииСотрудников;
	КадровыйРезервПозиций = ДополнительныеПараметры.КадровыйРезервПозиций;
	
	ОбластьПодразделение 				= ПараметрыМакета.ОбластьПодразделение;
	ОбластьДанныеПозиции 				= ПараметрыМакета.ОбластьДанныеПозиции;
	ОбластьСотрудник 					= ПараметрыМакета.ОбластьСотрудник;
	ОбластьСотрудникФото 				= ПараметрыМакета.ОбластьСотрудникФото;
	ОбластьКадровыйРезервНачало 		= ПараметрыМакета.ОбластьКадровыйРезервНачало;
	ОбластьКадровыйРезервПродолжение 	= ПараметрыМакета.ОбластьКадровыйРезервПродолжение;
	ОбластьКадровыйРезервОкончание 		= ПараметрыМакета.ОбластьКадровыйРезервОкончание;
	ОбластьЧертаСлева 					= ПараметрыМакета.ОбластьЧертаСлева;
	ОбластьУгол 						= ПараметрыМакета.ОбластьУгол;
	ОбластьПустойБлок 					= ПараметрыМакета.ОбластьПустойБлок;
	
	ДатаОтчета 						= НастройкиОтчета.ДатаОтчета;
	ВыводитьКоличествоСтавок 		= НастройкиОтчета.ВыводитьКоличествоСтавок;
	ВыводитьКадровыйРезерв 			= НастройкиОтчета.ВыводитьКадровыйРезерв;
	ВыводитьСотрудников 			= НастройкиОтчета.ВыводитьСотрудников;
	ВыводитьФотографииСотрудников 	= НастройкиОтчета.ВыводитьФотографииСотрудников;
	
	ДокументРезультат.Вывести(ОбластьПустойБлок);
	
	ОбластьПодразделение.Параметры.ПодразделениеНаименование = ДанныеПозиции.ПозицияНаименование;
	ОбластьПодразделение.Параметры.Подразделение = ДанныеПозиции.Позиция;
	ДокументРезультат.Вывести(ОбластьПодразделение);
	
	Если ВыводитьКоличествоСтавок Тогда
		ОбластьДанныеПозиции.Параметры.КоличествоСтавок = ДанныеПозиции.КоличествоСтавок;
		ОбластьДанныеПозиции.Параметры.СвободноСтавок = ДанныеПозиции.КоличествоСтавок - ДанныеПозиции.ЗанятоСтавок;
		ДокументРезультат.Вывести(ОбластьДанныеПозиции);
	КонецЕсли;
	
	Если ВыводитьКадровыйРезерв Тогда 
		КадровыйРезервПозиции = КадровыйРезервПозиций[ДанныеПозиции.Позиция];
		Если КадровыйРезервПозиции <> Неопределено И КадровыйРезервПозиции.Количество() > 0 Тогда 
			ДокументРезультат.Вывести(ОбластьКадровыйРезервНачало);
			МаксимальныйИндекс = КадровыйРезервПозиции.Количество() - 1;
			Для Каждого ДанныеФизическогоЛица Из КадровыйРезервПозиции Цикл 
				ВыводимаяОбласть = ?(КадровыйРезервПозиции.Индекс(ДанныеФизическогоЛица) = МаксимальныйИндекс, ОбластьКадровыйРезервОкончание, ОбластьКадровыйРезервПродолжение);
				ВыводимаяОбласть.Параметры.ФизическоеЛицо = ДанныеФизическогоЛица.Значение;
				ВыводимаяОбласть.Параметры.ФИОПолные = ДанныеФизическогоЛица.Представление;
				ДокументРезультат.Вывести(ВыводимаяОбласть);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если ВыводитьСотрудников Тогда
		ТабличныйДокумент = Новый ТабличныйДокумент;
		Для Каждого ДанныеСотрудника Из ДанныеПозиции.Строки Цикл 
			Если ЗначениеЗаполнено(ДанныеСотрудника.Сотрудник) Тогда
				ВыводимаяОбласть = ?(ВыводитьФотографииСотрудников, ОбластьСотрудникФото, ОбластьСотрудник);
				ВыводимаяОбласть.Параметры.Сотрудник = ДанныеСотрудника.Сотрудник;
				ВыводимаяОбласть.Параметры.ФИОПолные = ДанныеСотрудника.ФИОПолные;
				ВыводимаяОбласть.Параметры.ТабельныйНомер = ДанныеСотрудника.ТабельныйНомер;
				ВыводимаяОбласть.Параметры.Возраст = ПредставлениеВозраста(ДанныеСотрудника.ДатаРождения, ДатаОтчета);
				Если ВыводитьФотографииСотрудников Тогда 
					Фотография = ФотографииСотрудников.Получить(ДанныеСотрудника.Сотрудник);
					ВыводимаяОбласть.Рисунки.Фотография.Картинка = ?(Фотография = Неопределено, Новый Картинка, Фотография);
				КонецЕсли;
				ТабличныйДокумент.Вывести(ВыводимаяОбласть);
			КонецЕсли;
		КонецЦикла;
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда 
			ДокументРезультат.Вывести(ОбластьУгол);
			ДокументРезультат.Вывести(ОбластьПустойБлок);
			ДокументРезультат.Присоединить(ТабличныйДокумент.ПолучитьОбласть(1, 1, ТабличныйДокумент.ВысотаТаблицы, ТабличныйДокумент.ШиринаТаблицы));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПредставлениеВозраста(ДатаРождения, ДатаАктуальности);
	
	Если Не ЗначениеЗаполнено(ДатаРождения) Или Не ЗначениеЗаполнено(ДатаАктуальности) Тогда 
		Возврат "";
	КонецЕсли;
	
	Возраст = Год(ДатаАктуальности) - Год(ДатаРождения) + 
		?(Месяц(ДатаАктуальности) * 100 + День(ДатаАктуальности) >= Месяц(ДатаРождения) * 100 + День(ДатаРождения), 0, -1);
	
	ПоследняяЦифра = Прав(Возраст, 1);
	Если СтрНайти("0,5,6,7,8,9", ПоследняяЦифра) <> 0 Тогда 
		ВозрастШаблон = НСтр("ru='%1 лет';uk='%1 років'");
	Иначе 
		ПоследниеДвеЦифры = Прав(Возраст, 2);
		ПоследниеДвеЦифры = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(ПоследниеДвеЦифры, 2, "0");
		Если ПоследняяЦифра = "1" Тогда 
			ВозрастШаблон = ?(ПоследниеДвеЦифры = "11", НСтр("ru='%1 лет';uk='%1 років'"), НСтр("ru='%1 год';uk='%1 рік'"));
		Иначе
			ВозрастШаблон = ?(Найти("12,13,14", ПоследниеДвеЦифры) = 0, НСтр("ru='%1 года';uk='%1 року'"), НСтр("ru='%1 лет';uk='%1 років'"));
		КонецЕсли;
	КонецЕсли;
	ВозрастТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ВозрастШаблон, Возраст);
	
	Возврат ВозрастТекст;
	
КонецФункции

Функция ПараметрыОтчета(ДанныеОтчета, ДатаОтчета)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Отчет.ОрганизационнаяСтруктура.ПФ_MXL_ОрганизационнаяСтруктура");
	
	ОбластьПодразделение = Макет.ПолучитьОбласть("R3C2:R4C7");
	ОбластьРуководительПодразделения = Макет.ПолучитьОбласть("R13C2:R15C7");
	ОбластьДанныеПозиции = Макет.ПолучитьОбласть("R6C2:R7C7");
	ОбластьСотрудник = Макет.ПолучитьОбласть("R6C9:R6C18");
	ОбластьСотрудникФото = Макет.ПолучитьОбласть("R9C2:R11C12");
	ОбластьКадровыйРезервНачало = Макет.ПолучитьОбласть("R9C14:R9C19");
	ОбластьКадровыйРезервПродолжение = Макет.ПолучитьОбласть("R10C14:R10C19");
	ОбластьКадровыйРезервОкончание = Макет.ПолучитьОбласть("R11C14:R11C19");
	ОбластьЧертаСлева = Макет.ПолучитьОбласть("R3C10:R3C10");
	ОбластьЧертаСнизу = Макет.ПолучитьОбласть("R3C13:R3C13");
	ОбластьУгол = Макет.ПолучитьОбласть("R3C11:R3C11");
	ОбластьПустойБлок = Макет.ПолучитьОбласть("R3C12:R3C12");
	
	ПараметрыМакета = Новый Структура;
	ПараметрыМакета.Вставить("ОбластьПодразделение", ОбластьПодразделение);
	ПараметрыМакета.Вставить("ОбластьРуководительПодразделения", ОбластьРуководительПодразделения);
	ПараметрыМакета.Вставить("ОбластьДанныеПозиции", ОбластьДанныеПозиции);
	ПараметрыМакета.Вставить("ОбластьСотрудник", ОбластьСотрудник);
	ПараметрыМакета.Вставить("ОбластьСотрудникФото", ОбластьСотрудникФото);
	ПараметрыМакета.Вставить("ОбластьКадровыйРезервНачало", ОбластьКадровыйРезервНачало);
	ПараметрыМакета.Вставить("ОбластьКадровыйРезервПродолжение", ОбластьКадровыйРезервПродолжение);
	ПараметрыМакета.Вставить("ОбластьКадровыйРезервОкончание", ОбластьКадровыйРезервОкончание);
	ПараметрыМакета.Вставить("ОбластьЧертаСлева", ОбластьЧертаСлева);
	ПараметрыМакета.Вставить("ОбластьЧертаСнизу", ОбластьЧертаСнизу);
	ПараметрыМакета.Вставить("ОбластьУгол", ОбластьУгол);
	ПараметрыМакета.Вставить("ОбластьПустойБлок", ОбластьПустойБлок);
	
	НастройкиОтчета = ЭтотОбъект.КомпоновщикНастроек.ПолучитьНастройки();
	
	ПараметрВыводитьРуководителей = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьРуководителей"));	
	ВыводитьРуководителей = ?(ПараметрВыводитьРуководителей = Неопределено, Ложь, ПараметрВыводитьРуководителей.Значение);
	
	ПараметрВыводитьКоличествоСтавок = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьКоличествоСтавок"));	
	ВыводитьКоличествоСтавок = ?(ПараметрВыводитьКоличествоСтавок = Неопределено, Ложь, ПараметрВыводитьКоличествоСтавок.Значение);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КадровыйРезерв") Тогда 
		ПараметрВыводитьКадровыйРезерв = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьКадровыйРезерв"));	
		ВыводитьКадровыйРезерв = ?(ПараметрВыводитьКадровыйРезерв = Неопределено, Ложь, ПараметрВыводитьКадровыйРезерв.Значение);
	Иначе 
		ВыводитьКадровыйРезерв = Ложь;
	КонецЕсли;
	
	ПараметрВыводитьСотрудников = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьСотрудников"));	
	ВыводитьСотрудников = ?(ПараметрВыводитьСотрудников = Неопределено, Ложь, ПараметрВыводитьСотрудников.Значение);
	
	ПараметрВыводитьФотографииСотрудников = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьФотографииСотрудников"));	
	ВыводитьФотографииСотрудников = ?(ПараметрВыводитьФотографииСотрудников = Неопределено, Ложь, ПараметрВыводитьФотографииСотрудников.Значение);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ДатаОтчета", ДатаОтчета);
	СтруктураНастроек.Вставить("ВыводитьРуководителей", ВыводитьРуководителей);
	СтруктураНастроек.Вставить("ВыводитьКоличествоСтавок", ВыводитьКоличествоСтавок);
	СтруктураНастроек.Вставить("ВыводитьКадровыйРезерв", ВыводитьКадровыйРезерв);
	СтруктураНастроек.Вставить("ВыводитьСотрудников", ВыводитьСотрудников);
	СтруктураНастроек.Вставить("ВыводитьФотографииСотрудников", ВыводитьФотографииСотрудников);
	
	РуководителиПодразделений = ?(ВыводитьРуководителей, РуководителиПодразделений(ДанныеОтчета), Неопределено);
	ФотографииСотрудников = ?(ВыводитьФотографииСотрудников, ФотографииСотрудников(ДанныеОтчета), Неопределено); 
	КадровыйРезервПозиций = ?(ВыводитьКадровыйРезерв, КадровыйРезервПозиций(ДанныеОтчета, ДатаОтчета), Неопределено);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыМакета", ПараметрыМакета);
	ДополнительныеПараметры.Вставить("НастройкиОтчета", СтруктураНастроек);
	ДополнительныеПараметры.Вставить("РуководителиПодразделений", РуководителиПодразделений);
	ДополнительныеПараметры.Вставить("ФотографииСотрудников", ФотографииСотрудников);
	ДополнительныеПараметры.Вставить("КадровыйРезервПозиций", КадровыйРезервПозиций);
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

Функция РуководителиПодразделений(ДанныеОтчета)
	
	УникальныеПодразделения = Новый Соответствие;
	ЗаполнитьПодразделения(ДанныеОтчета, УникальныеПодразделения);
	
	
	РуководителиПодразделений = Новый Соответствие;
	
	Возврат РуководителиПодразделений;
	
КонецФункции

Процедура ЗаполнитьПодразделения(ДанныеОтчета, УникальныеПодразделения)
	
	Для Каждого СтрокаДанных Из ДанныеОтчета.Строки Цикл
		Если ЗначениеЗаполнено(СтрокаДанных.Подразделение) Тогда 
			Если ЗначениеЗаполнено(СтрокаДанных.Позиция) Тогда
				Продолжить;
			КонецЕсли;
			УникальныеПодразделения.Вставить(СтрокаДанных.Подразделение, Истина);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ФотографииСотрудников(ДанныеОтчета)
	
	УникальныеСотрудники = Новый Соответствие;
	ЗаполнитьВыбранныхСотрудников(ДанныеОтчета, УникальныеСотрудники);
	
	СписокСотрудников = ОбщегоНазначения.ВыгрузитьКолонку(УникальныеСотрудники, "Ключ");
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("СписокСотрудников", СписокСотрудников);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Сотрудники.Ссылка КАК Сотрудник,
	               |	ХранимыеФайлыВерсий.ХранимыйФайл
	               |ИЗ
	               |	Справочник.Сотрудники КАК Сотрудники
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ХранимыеФайлыВерсий КАК ХранимыеФайлыВерсий
	               |		ПО (Сотрудники.Ссылка В (&СписокСотрудников))
	               |			И Сотрудники.ФизическоеЛицо.Фотография.ТекущаяВерсия = ХранимыеФайлыВерсий.ВерсияФайла";
				   
	ФотографииСотрудников = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Фотография = Новый Картинка(Выборка.ХранимыйФайл.Получить());
		ФотографииСотрудников.Вставить(Выборка.Сотрудник, Фотография);
	КонецЦикла;
	
	Возврат ФотографииСотрудников;
	
КонецФункции

Процедура ЗаполнитьВыбранныхСотрудников(ДанныеОтчета, УникальныеСотрудники)
	
	Для Каждого СтрокаДанных Из ДанныеОтчета.Строки Цикл 
		Если ЗначениеЗаполнено(СтрокаДанных.Сотрудник) Тогда 
			УникальныеСотрудники.Вставить(СтрокаДанных.Сотрудник, Истина);
		Иначе
			ЗаполнитьВыбранныхСотрудников(СтрокаДанных, УникальныеСотрудники);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция КадровыйРезервПозиций(ДанныеОтчета, ДатаОтчета)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КадровыйРезерв") Тогда 
		Возврат Новый Соответствие;
	КонецЕсли;
	
	СписокПозиций = Новый Массив;
	ЗаполнитьСписокПозиций(ДанныеОтчета, СписокПозиций);
	
	Модуль = ОбщегоНазначения.ОбщийМодуль("КадровыйРезерв");
	КадровыйРезервПозиций = Модуль.СогласованныйРезервПозиций(СписокПозиций, ДатаОтчета);
	
	Возврат КадровыйРезервПозиций;
	
КонецФункции

Процедура ЗаполнитьСписокПозиций(ДанныеОтчета, СписокПозиций)
	
	Для Каждого СтрокаДанных Из ДанныеОтчета.Строки Цикл 
		Если ЗначениеЗаполнено(СтрокаДанных.Позиция) Тогда 
			Если Не СтрокаДанных.ПозицияЭтоГруппа Тогда
				СписокПозиций.Добавить(СтрокаДанных.Позиция);
			КонецЕсли;
		Иначе 
			ЗаполнитьСписокПозиций(СтрокаДанных, СписокПозиций);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьДатуОтчета(НастройкиОтчета, ДатаОтчета)
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ЗначениеПараметра <> Неопределено Тогда
		Если ТипЗнч(ЗначениеПараметра.Значение) = Тип("Дата") 
			Или ТипЗнч(ЗначениеПараметра.Значение) = Тип("СтандартнаяДатаНачала") Тогда
			Дата = Дата(ЗначениеПараметра.Значение);
			Если Дата = '00010101' Тогда
				ЗначениеПараметра.Значение = ТекущаяДатаСеанса();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ДатаОтчета = ЗначениеПараметра.Значение;
	Если ТипЗнч(ДатаОтчета) = Тип("СтандартнаяДатаНачала") Тогда
		ДатаОтчета = ДатаОтчета.Дата;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти
	
#КонецЕсли
