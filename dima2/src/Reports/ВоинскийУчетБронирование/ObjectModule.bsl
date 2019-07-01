#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	ИнициализироватьОтчет();

	СтандартнаяОбработка = Ложь;
	
	НастройкиОтчета = ЭтотОбъект.КомпоновщикНастроек.ПолучитьНастройки();				   

	УстановитьЗначенияПараметров(НастройкиОтчета);
	
	ДокументРезультат.Очистить();
	
	КлючВарианта = ЗарплатаКадрыОтчеты.КлючВарианта(КомпоновщикНастроек);
	Если КлючВарианта = "ЧисленностьРаботающихИЗабронированныхГражданЗапаса" Тогда
		
		// Параметры документа
		ДокументРезультат.ТолькоПросмотр = Истина;
		ДокументРезультат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЧисленностьРаботающихИЗабронированныхГражданЗапаса";
		ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
		
		ДатаОтчета = '00010101';
		
		УстановитьДатуОтчета(НастройкиОтчета, ДатаОтчета);
		
		ДанныеОтчета = Новый ДеревоЗначений;
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
		НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
		СоответствиеПользовательскихПолей = ЗарплатаКадрыОтчеты.СоответствиеПользовательскихПолей(НастройкиОтчета);
		// Создадим и инициализируем процессор компоновки.
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
		
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ПроцессорВывода.УстановитьОбъект(ДанныеОтчета);
		
		// Обозначим начало вывода
		ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
		
		ВывестиМакетЧисленностьРаботающихИЗабронированныхГражданЗапаса(ДокументРезультат, ДанныеОтчета, ДатаОтчета, СоответствиеПользовательскихПолей);
		
	ИначеЕсли КлючВарианта = "ДонесениеОКоличествеГражданВЗапасе" Тогда
		
		// Параметры документа
		ДокументРезультат.ТолькоПросмотр = Истина;
		ДокументРезультат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ДонесениеОКоличествеГражданВЗапасе";
		ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
		
		ДатаОтчета = '00010101';
		
		УстановитьДатуОтчета(НастройкиОтчета, ДатаОтчета);
		
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
		
		ВывестиМакетДонесениеОКоличествеГражданВЗапасе(ДокументРезультат, ДанныеОтчета, ДатаОтчета);
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

////////////////////////////////////////////////////////////////////////////////
// Функции формирования отчета по макету ЧисленностьРаботающихИЗабронированныхГражданЗапаса.

Процедура ВывестиМакетЧисленностьРаботающихИЗабронированныхГражданЗапаса(ДокументРезультат, ДанныеОтчета, ДатаОтчета, СоответствиеПользовательскихПолей)
	
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Макет 		  = УправлениеПечатью.МакетПечатнойФормы("Отчет.ВоинскийУчетБронирование.ПФ_MXL_UK_ЧисленностьРаботающихИЗабронированныхГражданЗапаса");
	Заголовок 	  = Макет.ПолучитьОбласть("Заголовок");
	Шапка 		  = Макет.ПолучитьОбласть("Шапка");
	СтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
	Подвал 		  = Макет.ПолучитьОбласть("Подвал");
	Итоги 		  = Макет.ПолучитьОбласть("Итоги");
	
	
	Для Каждого ДанныеОрганизации Из ДанныеОтчета.Строки Цикл
		
		ПараметрыЗаголовка = ПараметрыЗаголовкаСтруктура(ДанныеОрганизации.Организация, ДатаОтчета);
		
		ЗаполнитьЗначенияСвойств(Заголовок.Параметры, ПараметрыЗаголовка);
		ЗаполнитьЗначенияСвойств(Подвал.Параметры, ПараметрыЗаголовка);
		
		ДокументРезультат.Вывести(Заголовок);
		ДокументРезультат.Вывести(Шапка);
		
		СтрокиОтчета = СформироватьТаблицуСтрокиОтчета();
		
		ЗаполнитьЗначенияСвойств(Итоги.Параметры, ДанныеОрганизации);
		Итоги.Параметры.ПрапорщиковСолдатДо35Забронировано = ДанныеОрганизации[СоответствиеПользовательскихПолей["ПрапорщиковСолдатДо35Забронировано"]];
		Итоги.Параметры.ПрапорщиковСолдатОт35До40Забронировано = ДанныеОрганизации[СоответствиеПользовательскихПолей["ПрапорщиковСолдатОт35До40Забронировано"]];
		Итоги.Параметры.ПрапорщиковСолдатОт40До45Забронировано = ДанныеОрганизации[СоответствиеПользовательскихПолей["ПрапорщиковСолдатОт40До45Забронировано"]];
		Итоги.Параметры.ПрапорщиковСолдатОт45До60Забронировано = ДанныеОрганизации[СоответствиеПользовательскихПолей["ПрапорщиковСолдатОт45До60Забронировано"]];
		Для Каждого СтрокаГруппировки Из ДанныеОрганизации.Строки Цикл
			
				
			ЗаполнитьДанныеГруппировки(СтрокаГруппировки, СтрокиОтчета, СоответствиеПользовательскихПолей);
            ЗаполнитьЗначенияСвойств(СтрокиОтчета, СтрокаГруппировки);
			
		КонецЦикла;
		
		Для Каждого СтрокаОтчета Из СтрокиОтчета Цикл
			
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы.Параметры, СтрокаОтчета);
			СтрокаТаблицы.Параметры.ПрапорщиковСолдатДо35Забронировано = СтрокаОтчета.ПрапорщиковСолдатДо35Забронировано;
			ДокументРезультат.Вывести(СтрокаТаблицы);
			
		КонецЦикла;
		
		ДокументРезультат.Вывести(Итоги);
		
		ЗаполнитьПодписантов(Подвал, ДанныеОрганизации.Организация, ДатаОтчета);
		ДокументРезультат.Вывести(Подвал);
		
		ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьДанныеГруппировки(СтрокаГруппировки, СтрокиОтчета, СоответствиеПользовательскихПолей)
	
	СтрокаОтчета = СтрокиОтчета.Найти(СтрокаГруппировки.КатегорияВоинскогоУчета, "Категория");
	
	Если СтрокаОтчета <> Неопределено Тогда 
		
		ЗаполнитьЗначенияСвойств(СтрокаОтчета, СтрокаГруппировки);
		СтрокаОтчета.ПрапорщиковСолдатДо35Забронировано = СтрокаГруппировки[СоответствиеПользовательскихПолей["ПрапорщиковСолдатДо35Забронировано"]];
		СтрокаОтчета.ПрапорщиковСолдатОт35До40Забронировано = СтрокаГруппировки[СоответствиеПользовательскихПолей["ПрапорщиковСолдатОт35До40Забронировано"]];
		СтрокаОтчета.ПрапорщиковСолдатОт40До45Забронировано = СтрокаГруппировки[СоответствиеПользовательскихПолей["ПрапорщиковСолдатОт40До45Забронировано"]];
		СтрокаОтчета.ПрапорщиковСолдатОт45До60Забронировано = СтрокаГруппировки[СоответствиеПользовательскихПолей["ПрапорщиковСолдатОт45До60Забронировано"]];

	КонецЕсли;
	
КонецПроцедуры

Процедура ОписаниеСтрокиДанных(ТДанных, НомерСтрокиОтчета, ИмяСтрокиОтчета, Категория)
	
	Строка = ТДанных.Добавить();
	Строка.НомерСтрокиОтчета = НомерСтрокиОтчета;
	Строка.ИмяСтрокиОтчета = ИмяСтрокиОтчета;
	Строка.Категория = Категория;

КонецПроцедуры

Функция СформироватьТаблицуСтрокиОтчета()
	
	ТДанных = Новый ТаблицаЗначений;
	
	ТДанных.Колонки.Добавить("НомерСтрокиОтчета", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(10)));
	ТДанных.Колонки.Добавить("ИмяСтрокиОтчета",   Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(100)));
	ТДанных.Колонки.Добавить("Категория", 		  Новый ОписаниеТипов("СправочникСсылка.КатегорииДолжностей"));
	
	ТипЧисло = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15));
	
	ТДанных.Колонки.Добавить("ВсегоРаботающих", 						  ТипЧисло);
	ТДанных.Колонки.Добавить("ВсегоВЗапасе", 							  ТипЧисло);
	ТДанных.Колонки.Добавить("ОфицеровВЗапасе", 						  ТипЧисло);
	ТДанных.Колонки.Добавить("ПрапорщиковВЗапасе", 				  		  ТипЧисло);
	ТДанных.Колонки.Добавить("СолдатВЗапасе", 							  ТипЧисло);
	ТДанных.Колонки.Добавить("ВсегоВЗапасеЗабронировано", 				  ТипЧисло);
	
	ТДанных.Колонки.Добавить("ОфицеровЗабронировано", 					  ТипЧисло);
	ТДанных.Колонки.Добавить("ПрапорщиковСолдатДо35Забронировано", 		  ТипЧисло);
	ТДанных.Колонки.Добавить("ПрапорщиковСолдатОт35До40Забронировано",	  ТипЧисло);
	ТДанных.Колонки.Добавить("ПрапорщиковСолдатОт40До45Забронировано",	  ТипЧисло);
	ТДанных.Колонки.Добавить("ПрапорщиковСолдатОт45До60Забронировано",	  ТипЧисло);
	ТДанных.Колонки.Добавить("НезабронированоБезМобпредписаний", 		  ТипЧисло);
	КатегорииВоинскогоУчета 	  = Справочники.КатегорииДолжностей;
	
							
	ОписаниеСтрокиДанных(ТДанных, "1",  НСтр("uk='Керівники'"), 													КатегорииВоинскогоУчета.Руководители);
	ОписаниеСтрокиДанных(ТДанных, "2",  НСтр("uk='Професіонали'"), 													КатегорииВоинскогоУчета.Профессионалы);
	ОписаниеСтрокиДанных(ТДанных, "3",  НСтр("uk='Фахівці'"),			    										КатегорииВоинскогоУчета.Специалисты);
	ОписаниеСтрокиДанных(ТДанных, "4",  НСтр("uk='Технічні службовці'"), 											КатегорииВоинскогоУчета.ТехническиеСлужащие);
	ОписаниеСтрокиДанных(ТДанных, "5",  НСтр("uk='Працівники сфери торгівлі та послуг'"), 							КатегорииВоинскогоУчета.РаботникиСферыТорговлиИУслуг);
	ОписаниеСтрокиДанных(ТДанных, "6",  НСтр("uk='Кваліфіковані робітники сільського та
											|лісового господарства, риборозведення 
											|та рибальства'"), 														КатегорииВоинскогоУчета.КвалифицированныеРаботникиСХ);
	ОписаниеСтрокиДанных(ТДанных, "7",  НСтр("uk='Кваліфіковані робітники з інструментом'"),						КатегорииВоинскогоУчета.КвалифицированныеРаботникиСИнструментом);
	ОписаниеСтрокиДанных(ТДанных, "8",  НСтр("uk='Робітники з обслуговування, експлуатації 
											|та контролювання за роботою 
											|технологічного устаткування, складання
											|устаткування та машин'"),												КатегорииВоинскогоУчета.Рабочие);
	ОписаниеСтрокиДанных(ТДанных, "9",  НСтр("uk='Найпростіші професії'"), 											КатегорииВоинскогоУчета.ДругиеСлужащие);
	
	Возврат ТДанных;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции формирования отчета по макету ДонесениеОКоличествеГражданВЗапасе.

Процедура ВывестиМакетДонесениеОКоличествеГражданВЗапасе(ДокументРезультат, ДанныеОтчета, ДатаОтчета)
	
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Макет 		  = УправлениеПечатью.МакетПечатнойФормы("Отчет.ВоинскийУчетБронирование.ПФ_MXL_ДонесениеОКоличествеГражданВЗапасе");
	Заголовок 	  = Макет.ПолучитьОбласть("Заголовок");
	Шапка 		  = Макет.ПолучитьОбласть("Шапка");
	СтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
	Подвал 		  = Макет.ПолучитьОбласть("Подвал");
	
	Для Каждого ДанныеОрганизации Из ДанныеОтчета.Строки Цикл
		
		ПараметрыЗаголовка = ПараметрыЗаголовкаСтруктура(ДанныеОрганизации.Организация, ДатаОтчета);
		
		ЗаполнитьЗначенияСвойств(Заголовок.Параметры, ПараметрыЗаголовка);
		
		ДокументРезультат.Вывести(Заголовок);
		ДокументРезультат.Вывести(Шапка);
		
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы.Параметры, ДанныеОрганизации);
		
		СтрокаТаблицы.Параметры.ЗабронированоПроцент 					= ?(ЗначениеЗаполнено(ДанныеОрганизации.ВсегоВЗапасе), ДанныеОрганизации.ВсегоВЗапасеЗабронировано * 100 / ДанныеОрганизации.ВсегоВЗапасе, 0);
		СтрокаТаблицы.Параметры.НезабронированоСМобпредписаниемПроцент = ?(ЗначениеЗаполнено(ДанныеОрганизации.ВсегоВЗапасе), ДанныеОрганизации.НезабронированоСМобпредписанием * 100 / ДанныеОрганизации.ВсегоВЗапасе, 0);
		
		ДокументРезультат.Вывести(СтрокаТаблицы);
		
		ЗаполнитьЗначенияСвойств(Подвал.Параметры, ПараметрыЗаголовка);
		
		ЗаполнитьПодписантов(Подвал, ДанныеОрганизации.Организация, ДатаОтчета);
		ДокументРезультат.Вывести(Подвал);
		
		ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
			
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Универсальные процедуры и Функции.

Процедура УстановитьДатуОтчета(НастройкиОтчета, ДатаОтчета)
	
	ЗначениеПараметраПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	
	Если ЗначениеПараметраПериод <> Неопределено Тогда
		
		УстановитьДатуОтчета = Ложь;
		
		Если ТипЗнч(ЗначениеПараметраПериод.Значение) = Тип("Неопределено") Тогда
			УстановитьДатуОтчета = Истина;
		КонецЕсли;
		
		Если ТипЗнч(ЗначениеПараметраПериод.Значение) = Тип("Дата")
			И ЗначениеПараметраПериод.Значение = '00010101' Тогда
			УстановитьДатуОтчета = Истина;
		КонецЕсли; 
		
		Если ТипЗнч(ЗначениеПараметраПериод.Значение) = Тип("СтандартнаяДатаНачала")
			И Дата(ЗначениеПараметраПериод.Значение) = '00010101' Тогда
			УстановитьДатуОтчета = Истина;
		КонецЕсли; 
		
		Если УстановитьДатуОтчета Тогда
			ЗначениеПараметраПериод.Значение = ТекущаяДатаСеанса();
		КонецЕсли; 
		
		ДатаОтчета = Дата(ЗначениеПараметраПериод.Значение);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьЗначенияПараметров(НастройкиОтчета)
	
	Специалисты = Новый Массив;
	Специалисты.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.СпециалистыЗдравоохранение);
	Специалисты.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.СпециалистыОбрабатывающиеПроизводства);
	Специалисты.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.СпециалистыОбразования);
	Специалисты.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.СпециалистыПолезныеИскопаемые);
	Специалисты.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.СпециалистыПроизводствоЭлектроэнергии);
	Специалисты.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.СпециалистыСтроительство);
	Специалисты.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.СпециалистыСХ);
	Специалисты.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.СпециалистыТранспорт);
	Специалисты.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.ПрочиеСпециалисты);
	
	Рабочие = Новый Массив;
	Рабочие.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.РабочиеИмеющиеТарифныйРазряд);
	Рабочие.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.РабочиеЛокомотивныхБригад);
	Рабочие.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.РабочиеНеИмеющиеТарифныхРазрядов);
	Рабочие.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.РабочиеСХ);
	Рабочие.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.Трактористы);
	Рабочие.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.Водители);
	
	ПараметрСпециалисты = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Специалисты"));	
	
	Если ПараметрСпециалисты <> Неопределено Тогда
		ПараметрСпециалисты.Значение = Специалисты;
		ПараметрСпециалисты.Использование = Истина;
	КонецЕсли;
	
	ПараметрРабочие = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Рабочие"));	
	
	Если ПараметрРабочие <> Неопределено Тогда
		ПараметрРабочие.Значение = Рабочие;
		ПараметрРабочие.Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция ПараметрыЗаголовкаСтруктура(Организация, ДатаОтчета)
	
	ПараметрыЗаголовка = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, "Наименование, НаименованиеПолное");
	
	ПолноеНаименованиеОрганизации = ?(ЗначениеЗаполнено(ПараметрыЗаголовка.НаименованиеПолное), ПараметрыЗаголовка.НаименованиеПолное, ПараметрыЗаголовка.Наименование);
	
	ПараметрыЗаголовка.Вставить("ДатаОтчета", Формат(ДатаОтчета,("Л=uk; ДФ=dd.MM.yyyy")));
	ПараметрыЗаголовка.Вставить("Организация", Организация);
	ПараметрыЗаголовка.Вставить("ПолноеНаименованиеОрганизации", ПолноеНаименованиеОрганизации);
	
	Возврат ПараметрыЗаголовка;
	
КонецФункции

Процедура ЗаполнитьПодписантов(Макет, Организация, ДатаОтчета)
	
	ПараметрыЗаполнения = Новый Структура("ДолжностьРуководителя,Руководитель,РуководительРасшифровкаПодписи");
	КлючиОтветственныхЛиц = "";
	
	НастройкиОтчета = ЭтотОбъект.КомпоновщикНастроек.ПолучитьНастройки();
	
	ПараметрРуководитель = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Руководитель"));	
	Если ПараметрРуководитель <> Неопределено И ПараметрРуководитель.Использование Тогда
		Если ЗначениеЗаполнено(ПараметрРуководитель.Значение) Тогда
			ПараметрыЗаполнения.Руководитель = ПараметрРуководитель.Значение;
		КонецЕсли; 
	Иначе
		КлючиОтветственныхЛиц = "Руководитель";
	КонецЕсли;
	
	ПараметрДолжностьРуководителя = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДолжностьРуководителя"));	
	Если ПараметрДолжностьРуководителя <> Неопределено И ПараметрДолжностьРуководителя.Использование Тогда
		ПараметрыЗаполнения.ДолжностьРуководителя = ПараметрДолжностьРуководителя.Значение;
	Иначе
		КлючиОтветственныхЛиц = ?(ПустаяСтрока(КлючиОтветственныхЛиц), "", КлючиОтветственныхЛиц + ",") + "ДолжностьРуководителяСтрокой";
	КонецЕсли;
	
	Если Не ПустаяСтрока(КлючиОтветственныхЛиц) Тогда
		
		ОтветственныеЛица = Новый Структура("Организация," + КлючиОтветственныхЛиц, Организация);
		ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ОтветственныеЛица, ДатаОтчета);
		
		ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, ОтветственныеЛица);
		Если ОтветственныеЛица.Свойство("ДолжностьРуководителяСтрокой") Тогда
			ПараметрыЗаполнения.ДолжностьРуководителя = ОтветственныеЛица.ДолжностьРуководителяСтрокой;
		КонецЕсли; 
		
	КонецЕсли; 
	
	МассивФизЛиц = Новый Массив;
	Если ЗначениеЗаполнено(ПараметрыЗаполнения.Руководитель) Тогда
		МассивФизЛиц.Добавить(ПараметрыЗаполнения.Руководитель);
	КонецЕсли; 
		
	Если МассивФизЛиц.Количество() > 0 Тогда
		
		ФИОФизЛиц = ЗарплатаКадры.СоответствиеФИОФизЛицСсылкам(ДатаОтчета, МассивФизЛиц);
		ПараметрыЗаполнения.РуководительРасшифровкаПодписи = ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ФИОФизЛиц[ПараметрыЗаполнения.Руководитель]);

	КонецЕсли; 
	
	Макет.Параметры.Заполнить(ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

