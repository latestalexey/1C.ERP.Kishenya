
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
	
	ПараметрыОтбора = ХранилищеНастроекДанныхФорм.Загрузить("ОтчетПереработчикаРабочееМесто", "ПараметрыОтбора");
	Если ЗначениеЗаполнено(ПараметрыОтбора) Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ПараметрыОтбора);
	КонецЕсли;
	
	УстановитьТекущуюСтраницу();
	
	ОбновитьДанные();
	
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
	
	Если ИмяСобытия = "Запись_ОтчетПереработчика"
		ИЛИ ИмяСобытия = "Запись_ПередачаСырьяПереработчику" 
		ИЛИ ИмяСобытия = "Запись_ПоступлениеОтПереработчика" 
		ИЛИ ИмяСобытия = "Запись_ЗаказПереработчику" Тогда
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

&НаКлиенте
Процедура КомандаОбновитьДанные(Команда)
	
	ЗаполнитьОформлениеДокументов();
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьОтчетПереработчика(Команда)
	
	ВыделенныеСтроки = Элементы.ОформлениеДокументов.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Для оформления отчета необходимо выбрать продукцию.';uk='Для оформлення звіту необхідно вибрати продукцію.'"));
		Возврат;
	КонецЕсли;
	
	СписокСтрок = Новый Массив;
	Для каждого ИдентификаторСтроки Из Элементы.ОформлениеДокументов.ВыделенныеСтроки Цикл
		ДанныеСтроки = ОформлениеДокументов.НайтиПоИдентификатору(ИдентификаторСтроки);
		СписокСтрок.Добавить(ДанныеСтроки);
	КонецЦикла;
	
	ДанныеЗаполнения = ПроизводствоКлиент.ДанныеДляФормированияОтчетаПереработчику(СписокСтрок);
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("Основание", ДанныеЗаполнения);
		ОткрытьФорму("Документ.ОтчетПереработчика.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли; 
	
КонецПроцедуры

#Область ПодключаемыеКоманды

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

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОтчетПереработчика.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Ссылка = МассивСсылок[0];
		Элементы.Список.ТекущаяСтрока = Ссылка;
		ПоказатьЗначение(,МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()

	#Область СтандартноеОформление
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "ОформлениеДокументовХарактеристика",
																		     "ОформлениеДокументов.ХарактеристикиИспользуются");
																			 
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, 
																   "ОформлениеДокументовЕдИзм", 
                                                                   "ОформлениеДокументов.Упаковка");
	#КонецОбласти
	
	// Текст "<Без заказа>"
	#Область Текст_БезЗаказа
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОформлениеДокументовРаспоряжение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОформлениеДокументов.Распоряжение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<Без заказа>';uk='<Без замовлення>'"));
	#КонецОбласти
	
	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "СписокДата");
	
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
Процедура ОбновитьДанные()

	Элементы.Список.Обновить();
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
	|	ЕСТЬNULL(ДокЗаказПереработчику.Организация, ДокПоступлениеОтПереработчика.Организация) КАК Организация,
	|	ЕСТЬNULL(ДокЗаказПереработчику.Партнер, ДокПоступлениеОтПереработчика.Партнер)         КАК Переработчик,
	|	ВложенныйЗапрос.Распоряжение              КАК Распоряжение,
	|	ВложенныйЗапрос.КодСтроки                 КАК КодСтроки,
	|	ВложенныйЗапрос.Номенклатура              КАК Номенклатура,
	|	ВложенныйЗапрос.Характеристика            КАК Характеристика,
	|	ЕСТЬNULL(ТаблицаПродукция.Упаковка, ТаблицаОтходы.Упаковка) КАК Упаковка,
	|	СУММА(ВложенныйЗапрос.Поступило)          КАК Поступило,
	|	СУММА(ВложенныйЗапрос.Заказано)           КАК Заказано,
	|	СУММА(ВложенныйЗапрос.Поступило)          КАК ПоступилоУпаковок,
	|	СУММА(ВложенныйЗапрос.Заказано)           КАК ЗаказаноУпаковок,
	|	МАКСИМУМ(ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковкиПродукция, ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковкиОтходы, 1))) КАК КоэффициентУпаковки,
	|	ВЫБОР
	|		КОГДА ВложенныйЗапрос.Номенклатура.ИспользованиеХарактеристик В (
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры), 
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры), 
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры))
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ХарактеристикиИспользуются,
	|	ВЫРАЗИТЬ(ВложенныйЗапрос.Распоряжение КАК Документ.ЗаказПереработчику).Номер КАК НомерРаспоряжения,
	|	ВЫРАЗИТЬ(ВложенныйЗапрос.Распоряжение КАК Документ.ЗаказПереработчику).Дата КАК ДатаРаспоряжения,
	|	ЕСТЬNULL(ДокЗаказПереработчику.НаправлениеДеятельности, ДокПоступлениеОтПереработчика.НаправлениеДеятельности) КАК НаправлениеДеятельности
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаказыПоставщикам.ЗаказПоставщику    КАК Распоряжение,
	|		ЗаказыПоставщикам.КодСтроки          КАК КодСтроки,
	|		ЗаказыПоставщикам.Номенклатура       КАК Номенклатура,
	|		ЗаказыПоставщикам.Характеристика     КАК Характеристика,
	|		0 КАК Поступило,
	|		ЗаказыПоставщикам.КОформлениюОстаток КАК Заказано
	|	ИЗ
	|		РегистрНакопления.ЗаказыПоставщикам.Остатки(
	|				,
	|				ЗаказПоставщику ССЫЛКА Документ.ЗаказПереработчику
	|					И &УсловиеЗаблокированныеРаспоряжения1) КАК ЗаказыПоставщикам
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТоварыПолученныеОтПереработчикаОстатки.Распоряжение,
	|		ТоварыПолученныеОтПереработчикаОстатки.КодСтроки,
	|		ТоварыПолученныеОтПереработчикаОстатки.АналитикаУчетаНоменклатуры.Номенклатура,
	|		ТоварыПолученныеОтПереработчикаОстатки.АналитикаУчетаНоменклатуры.Характеристика,
	|		ВЫБОР 
	|			КОГДА ТоварыПолученныеОтПереработчикаОстатки.КоличествоОстаток > 0
	|					И ТоварыПолученныеОтПереработчикаОстатки.КодСтроки <> 0
	|				ТОГДА ТоварыПолученныеОтПереработчикаОстатки.КоличествоОстаток
	|			ИНАЧЕ 0 
	|		КОНЕЦ,
	|		ВЫБОР 
	|			КОГДА ТоварыПолученныеОтПереработчикаОстатки.КоличествоОстаток < 0
	|				ТОГДА ТоварыПолученныеОтПереработчикаОстатки.КоличествоОстаток
	|			ИНАЧЕ 0 
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.ТоварыПолученныеОтПереработчика.Остатки( 
	|				,
	|				&УсловиеЗаблокированныеРаспоряжения2) КАК ТоварыПолученныеОтПереработчикаОстатки
	|	) КАК ВложенныйЗапрос
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПереработчику КАК ДокЗаказПереработчику
	|	ПО (ДокЗаказПереработчику.Ссылка = ВложенныйЗапрос.Распоряжение)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеОтПереработчика КАК ДокПоступлениеОтПереработчика
	|	ПО (ДокПоступлениеОтПереработчика.Ссылка = ВложенныйЗапрос.Распоряжение)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПереработчику.Продукция КАК ТаблицаПродукция
	|	ПО (ТаблицаПродукция.Ссылка = ВложенныйЗапрос.Распоряжение)
	|		И (ТаблицаПродукция.КодСтроки = ВложенныйЗапрос.КодСтроки)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПереработчику.ВозвратныеОтходы КАК ТаблицаОтходы
	|	ПО (ТаблицаОтходы.Ссылка = ВложенныйЗапрос.Распоряжение)
	|		И (ТаблицаОтходы.КодСтроки = ВложенныйЗапрос.КодСтроки)
	|
	|ГДЕ
	|	(&Переработчик = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
	|			ИЛИ ДокЗаказПереработчику.Партнер = &Переработчик)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Распоряжение,
	|	ЕСТЬNULL(ДокЗаказПереработчику.Партнер, ДокПоступлениеОтПереработчика.Партнер),
	|	ЕСТЬNULL(ДокЗаказПереработчику.Организация, ДокПоступлениеОтПереработчика.Организация),
	|	ЕСТЬNULL(ТаблицаПродукция.Упаковка, ТаблицаОтходы.Упаковка),
	|	ВложенныйЗапрос.КодСтроки,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.Характеристика,
	|	ВЫБОР
	|		КОГДА ВложенныйЗапрос.Номенклатура.ИспользованиеХарактеристик В (
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры), 
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры), 
	|					ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры))
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ,
	|	ЕСТЬNULL(ДокЗаказПереработчику.НаправлениеДеятельности, ДокПоступлениеОтПереработчика.НаправлениеДеятельности)
	|
	|ИМЕЮЩИЕ
	|	СУММА(ВложенныйЗапрос.Поступило) <> 0 ИЛИ СУММА(ВложенныйЗапрос.Заказано) <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаРаспоряжения,
	|	НомерРаспоряжения,
	|	ВложенныйЗапрос.Распоряжение";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковкиПродукция",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"ТаблицаПродукция.Упаковка",
		"ТаблицаПродукция.Номенклатура"));
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковкиОтходы",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"ТаблицаОтходы.Упаковка",
		"ТаблицаОтходы.Номенклатура"));
		
	ТаблицыДляКонтроля = Новый Массив;
	ТаблицыДляКонтроля.Добавить("Документ.ЗаказПереработчику");
	ТаблицыДляКонтроля.Добавить("РегистрНакопления.ЗаказыПоставщикам");
	ТаблицыДляКонтроля.Добавить("РегистрНакопления.ТоварыПолученныеОтПереработчика");
	ЗаблокированныеРаспоряжения = Документы.ЗаказПереработчику.ВыбратьЗаблокированныеДляЧтенияИИзмененияСсылки(ТаблицыДляКонтроля);
	Если ЗаблокированныеРаспоряжения.Количество() <> 0 Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеЗаблокированныеРаспоряжения1", "НЕ ЗаказПоставщику В (&ЗаблокированныеРаспоряжения)");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеЗаблокированныеРаспоряжения2", "НЕ Распоряжение В (&ЗаблокированныеРаспоряжения)");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &УсловиеЗаблокированныеРаспоряжения1", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеЗаблокированныеРаспоряжения2", "");
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Переработчик", ОтборПереработчик);
	Запрос.УстановитьПараметр("ЗаблокированныеРаспоряжения", ЗаблокированныеРаспоряжения);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		ДанныеСтроки = ОформлениеДокументов.Добавить();
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, Выборка);
		
		ДанныеСтроки.Поступило = ДанныеСтроки.Поступило / Выборка.КоэффициентУпаковки;
		ДанныеСтроки.Заказано  = ДанныеСтроки.Заказано  / Выборка.КоэффициентУпаковки;
		
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

	ПараметрыОтбора = Новый Структура("ОтборПереработчик");

	ЗаполнитьЗначенияСвойств(ПараметрыОтбора, ЭтаФорма);
	ХранилищеНастроекДанныхФорм.Сохранить("ОтчетПереработчикаРабочееМесто", "ПараметрыОтбора", ПараметрыОтбора);

КонецПроцедуры

&НаСервере
Процедура ПереработчикПриИзмененииНаСервере()

	СохранитьПараметрыОтбора();
	ОбновитьДанные();

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
	|	РегистрНакопления.ЗаказыПоставщикам.Изменения КАК ТаблицаИзменений
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам КАК ТаблицаОбъекта
	|		ПО (ТаблицаОбъекта.Регистратор = ТаблицаИзменений.Регистратор)
	|			И (ТаблицаОбъекта.ЗаказПоставщику ССЫЛКА Документ.ЗаказПереработчику)
	|ГДЕ
	|	ТаблицаИзменений.Узел ССЫЛКА ПланОбмена.ОбновлениеИнформационнойБазы
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ТаблицаИзменений.Регистратор
	|ИЗ
	|	РегистрНакопления.ТоварыПолученныеОтПереработчика.Изменения КАК ТаблицаИзменений
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
