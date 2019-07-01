
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если ВыполняетсяОбновлениеЧитаемыхДанных() Тогда
		ОбновлениеИнформационнойБазыУТ.СообщитьЧтоРаботаСФормойВременноОграничена(); 
	КонецЕсли; 
	
	ПараметрыОтбора = ХранилищеНастроекДанныхФорм.Загрузить("ПоступлениеОтПереработчикаРабочееМесто", "ПараметрыОтбора");
	Если ЗначениеЗаполнено(ПараметрыОтбора) Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ПараметрыОтбора);
	КонецЕсли;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Склад", Склад);
		СтруктураБыстрогоОтбора.Свойство("Менеджер", Менеджер);
	КонецЕсли;

	ОбновитьДанные();
	
	УстановитьТекущуюСтраницу();
	ИспользоватьПоступлениеПоНесколькимЗаказам = ПолучитьФункциональнуюОпцию("ИспользоватьПоступлениеПоНесколькимЗаказам");
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.Менеджер.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.ПоступлениеОтПереработчика));
	
	#Область СтандартныеМеханизмы
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.СписокКоманднаяПанель);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	#КонецОбласти

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ЗаказПереработчику"
		ИЛИ ИмяСобытия = "Запись_ПоступлениеОтПереработчика" Тогда
		ОбновитьДанные();
	КонецЕсли;
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МенеджерПриИзменении(Элемент)
	
	МенеджерПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	СкладПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ПодразделениеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереработчикПриИзменении(Элемент)

	ПереработчикПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОформлениеДокументов

&НаКлиенте
Процедура ОформлениеДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ОформлениеДокументов.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Распоряжение) Тогда
		ПоказатьЗначение(,ТекущиеДанные.Распоряжение);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец МенюОтчеты


&НаКлиенте
Процедура СоздатьПоступлениеОтПереработчика(Команда)
	
	Если Элементы.ОформлениеДокументов.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	СписокСтрок = Новый Массив;
	Для каждого ИдентификаторСтроки Из Элементы.ОформлениеДокументов.ВыделенныеСтроки Цикл
		ДанныеСтроки = ОформлениеДокументов.НайтиПоИдентификатору(ИдентификаторСтроки);
		СписокСтрок.Добавить(ДанныеСтроки);
	КонецЦикла;
	
	ДанныеЗаполнения = ПроизводствоКлиент.ДанныеДляФормированияПоступленияОтПереработчика(СписокСтрок);
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("Основание", ДанныеЗаполнения);
		ОткрытьФорму("Документ.ПоступлениеОтПереработчика.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли; 
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОформлено Тогда
		ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	КонецЕсли;
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПоступлениеТоваровУслуг.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаказПоставщику.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ПоступлениеОтПереработчика") Тогда
			
			Элементы.Список.ТекущаяСтрока = Ссылка;
			Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.СтраницаОформлено;
			
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаказПереработчику") Тогда
			
			СтруктураПоиска = Новый Структура("Распоряжение", Ссылка);
   			СписокСтрок = ОформлениеДокументов.НайтиСтроки(СтруктураПоиска);
			Если СписокСтрок.Количество() <> 0 Тогда
				Элементы.ОформлениеДокументов.ТекущаяСтрока = СписокСтрок[0].ПолучитьИдентификатор();
			КонецЕсли;
			Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.СтраницаКОформлению;
			
		КонецЕсли;
		
		ПоказатьЗначение(,Ссылка);
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	#Область СтандартноеОформление
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "ОформлениеДокументовХарактеристика",
																		     "ОформлениеДокументов.ХарактеристикиИспользуются");
	#КонецОбласти
	
	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "СписокДата");
	
КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииНаСервере()

	СохранитьПараметрыОтбора();
	ОбновитьДанные();
	
КонецПроцедуры

&НаСервере
Процедура ПодразделениеПриИзмененииНаСервере()

	СохранитьПараметрыОтбора();
	ОбновитьДанные();

КонецПроцедуры

&НаСервере
Процедура ПереработчикПриИзмененииНаСервере()

	СохранитьПараметрыОтбора();
	ОбновитьДанные();

КонецПроцедуры

&НаСервере
Процедура МенеджерПриИзмененииНаСервере()

	СохранитьПараметрыОтбора();
	ОбновитьДанные();

КонецПроцедуры

&НаСервере
Процедура ОбновитьДанные()

	// Подразделение
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"Подразделение", 
			Подразделение,
			ВидСравненияКомпоновкиДанных.Равно,,
			ЗначениеЗаполнено(Подразделение));
			
	// Переработчик
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"Партнер", 
			Переработчик,
			ВидСравненияКомпоновкиДанных.Равно,,
			ЗначениеЗаполнено(Переработчик));
			
	// Менеджер
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"Менеджер", 
			Менеджер,
			ВидСравненияКомпоновкиДанных.Равно,,
			ЗначениеЗаполнено(Менеджер));
	
	ЗаполнитьОформлениеДокументов();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОформлениеДокументов()

	ТекущаяСтрока = Элементы.ОформлениеДокументов.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекущиеДанные = ОформлениеДокументов.НайтиПоИдентификатору(ТекущаяСтрока);
		ПараметрыТекущейСтроки = Новый Структура("КодСтроки,Распоряжение");
		ЗаполнитьЗначенияСвойств(ПараметрыТекущейСтроки, ТекущиеДанные);
	Иначе
		ПараметрыТекущейСтроки = Неопределено;
	КонецЕсли; 
	
	ОформлениеДокументов.Очистить();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказыПоставщикам.ЗаказПоставщику КАК Распоряжение,
	|	ДокЗаказПереработчику.Номер КАК НомерРаспоряжения,
	|	ДокЗаказПереработчику.Дата КАК ДатаРаспоряжения,
	|	ДокЗаказПереработчику.Партнер КАК Переработчик,
	|	ДокЗаказПереработчику.Контрагент КАК Контрагент,
	|	ДокЗаказПереработчику.Договор КАК Договор,
	|	ДокЗаказПереработчику.Организация КАК Организация,
	|	ЗаказыПоставщикам.Склад КАК Склад,
	|	ЗаказыПоставщикам.Склад.Родитель КАК ГруппаСкладов,
	|	ЗаказыПоставщикам.КодСтроки КАК КодСтроки,
	|	ЗаказыПоставщикам.Номенклатура КАК Номенклатура,
	|	ЗаказыПоставщикам.Характеристика КАК Характеристика,
	|	ЗаказыПоставщикам.КОформлениюОстаток КАК Заказано,
	|	ВЫБОР
	|		КОГДА ЗаказыПоставщикам.Номенклатура.ИспользованиеХарактеристик В (
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры), 
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры), 
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры))
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ХарактеристикиИспользуются,
	|	ДокЗаказПереработчику.НаправлениеДеятельности
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам.Остатки(
	|			,
	|			ЗаказПоставщику ССЫЛКА Документ.ЗаказПереработчику
	|				И &УсловиеЗаблокированныеРаспоряжения
	|				И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|					ИЛИ Склад = &Склад)) КАК ЗаказыПоставщикам
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПереработчику КАК ДокЗаказПереработчику
	|		ПО (ДокЗаказПереработчику.Ссылка = ЗаказыПоставщикам.ЗаказПоставщику)
	|ГДЕ
	|	(&Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|			ИЛИ ДокЗаказПереработчику.Подразделение = &Подразделение)
	|	И (&Переработчик = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
	|			ИЛИ ДокЗаказПереработчику.Партнер = &Переработчик)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаРаспоряжения,
	|	НомерРаспоряжения,
	|	Распоряжение";
	
	ТаблицыДляКонтроля = Новый Массив;
	ТаблицыДляКонтроля.Добавить("Документ.ЗаказПереработчику");
	ТаблицыДляКонтроля.Добавить("РегистрНакопления.ЗаказыПоставщикам");
	ЗаблокированныеРаспоряжения = Документы.ЗаказПереработчику.ВыбратьЗаблокированныеДляЧтенияИИзмененияСсылки(ТаблицыДляКонтроля);
	Если ЗаблокированныеРаспоряжения.Количество() <> 0 Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеЗаблокированныеРаспоряжения", "НЕ ЗаказПоставщику В (&ЗаблокированныеРаспоряжения)");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеЗаблокированныеРаспоряжения", "");
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Переработчик", Переработчик);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("ЗаблокированныеРаспоряжения", ЗаблокированныеРаспоряжения);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		ДанныеСтроки = ОформлениеДокументов.Добавить();
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, Выборка);
		
	КонецЦикла;
	
	СтрокКОформлению = ОформлениеДокументов.Количество();

	Если ПараметрыТекущейСтроки <> Неопределено Тогда
  		СписокСтрок = ОформлениеДокументов.НайтиСтроки(ПараметрыТекущейСтроки);
		Если СписокСтрок.Количество() <> 0 Тогда
			Элементы.ОформлениеДокументов.ТекущаяСтрока = СписокСтрок[0].ПолучитьИдентификатор();
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура СохранитьПараметрыОтбора()

	ПараметрыОтбора = Новый Структура("Подразделение,Переработчик,Склад");

	ЗаполнитьЗначенияСвойств(ПараметрыОтбора, ЭтаФорма);
	ХранилищеНастроекДанныхФорм.Сохранить("ПоступлениеОтПереработчикаРабочееМесто", "ПараметрыОтбора", ПараметрыОтбора);

КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюСтраницу()
	
	ИмяТекущейСтраницы = "";
	
	Если Параметры.Свойство("ИмяТекущейСтраницы", ИмяТекущейСтраницы) Тогда
		Если ЗначениеЗаполнено(ИмяТекущейСтраницы) Тогда
			ТекущийЭлемент = Элементы[ИмяТекущейСтраницы];
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыполняетсяОбновлениеЧитаемыхДанных()

	Если ПолучитьФункциональнуюОпцию("ОтложенноеОбновлениеЗавершеноУспешно") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ТаблицаИзменений.Регистратор
	|ИЗ
	|	РегистрНакопления.ТоварыКОтгрузке.Изменения КАК ТаблицаИзменений
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКОтгрузке КАК ТаблицаОбъекта
	|		ПО (ТаблицаОбъекта.Регистратор = ТаблицаИзменений.Регистратор)
	|			И (ТаблицаОбъекта.ДокументОтгрузки ССЫЛКА Документ.ЗаказПереработчику)
	|ГДЕ
	|	ТаблицаИзменений.Узел ССЫЛКА ПланОбмена.ОбновлениеИнформационнойБазы";
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции

// СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#КонецОбласти
