
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВидЦены                   = Параметры.ВидЦены;
	Цена                      = Параметры.Цена;
	Дата                      = Параметры.Дата;
	ДатаОтгрузки              = Параметры.ДатаОтгрузки;
	Склад                     = Параметры.Склад;
	Номенклатура              = Параметры.Номенклатура;
	Характеристика            = Параметры.Характеристика;
	Упаковка 				  = Параметры.Упаковка;
	Валюта                    = Параметры.Валюта;
	ЦенаВключаетНДС           = Параметры.ЦенаВключаетНДС;
	
	СтруктураНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура, "ЕдиницаИзмерения, ИспользоватьУпаковки");
		
	Если Упаковка.Пустая()
		И СтруктураНоменклатуры.ИспользоватьУпаковки Тогда 
		Упаковка = ПодборТоваровВызовСервера.ПолучитьУпаковкуХранения(Номенклатура);
	КонецЕсли;
	
	Если СтруктураНоменклатуры.ИспользоватьУпаковки Тогда
		Элементы.Упаковка.ПодсказкаВвода = СтруктураНоменклатуры.ЕдиницаИзмерения;
	КонецЕсли;
		
	СтараяУпаковка            = Упаковка;
	
	Элементы.ВидЦены.ТолькоПросмотр     = Не Параметры.РедактироватьВидЦены;
	Элементы.ВидЦены.ПропускатьПриВводе = Не Параметры.РедактироватьВидЦены;
	Элементы.Цена.ТолькоПросмотр        = Не Параметры.РедактироватьЦену;
	Элементы.Цена.ПропускатьПриВводе    = Не Параметры.РедактироватьЦену;
	
	НаименованиеТовара = "" + Параметры.Номенклатура + ?(ЗначениеЗаполнено(Параметры.Характеристика), " (" + Параметры.Характеристика + ")","");
	
	Если Параметры.СкрытьЦену Тогда
		Элементы.Цена.Видимость    = Ложь;
		Элементы.Валюта.Видимость  = Ложь;
		Элементы.ВидЦены.Видимость = Ложь;
		ЭтаФорма.АвтоЗаголовок     = Ложь;
		ЭтаФорма.Заголовок         = НСтр("ru='Ввод количества';uk='Введення кількості'");
	КонецЕсли;
	
	Если Не Параметры.ИспользоватьДатыОтгрузки Тогда
		Элементы.ДатаОтгрузки.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.ЭтоУслуга Тогда
		ДатаОтгрузки = '00010101';
		Склад = Справочники.Склады.ПустаяСсылка();
		Элементы.ДатаОтгрузки.Видимость = Ложь;
	КонецЕсли;
	
	Если Не Параметры.ИспользоватьСкладыВТабличнойЧасти Тогда
		Склад = Неопределено;
	КонецЕсли;
	
	Элементы.Склад.Видимость = (Не Параметры.ЭтоУслуга Или Не Параметры.ИспользоватьДатыОтгрузки) 
		И Параметры.Склады.Количество() > 1 И Параметры.ИспользоватьСкладыВТабличнойЧасти;
	ОбщегоНазначенияУТКлиентСервер.ДобавитьПараметрВыбора(Элементы.Склад, "Ссылка", Параметры.Склады);
	
	Элементы.Упаковка.Видимость = ЗначениеЗаполнено(Номенклатура.НаборУпаковок);
	Элементы.ЕдиницаИзмерения.Видимость = Не ЗначениеЗаполнено(Номенклатура.НаборУпаковок);
	
	КоличествоУпаковок = 1;
	
	// Заполнить список выбора видов цен.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыЦен.Ссылка КАК ВидЦен
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|ГДЕ
	|	Не ВидыЦен.ПометкаУдаления
	|	И ВидыЦен.ИспользоватьПриПродаже
	|	И (&БезОтбораПоВключениюНДСВЦену ИЛИ ВидыЦен.ЦенаВключаетНДС = &ЦенаВключаетНДС)");
	
	Запрос.УстановитьПараметр("ЦенаВключаетНДС", ЦенаВключаетНДС);
	БезОтбораПоВключениюНДСВЦену = Неопределено;
	Параметры.Свойство("БезОтбораПоВключениюНДСВЦену", БезОтбораПоВключениюНДСВЦену);
	Запрос.УстановитьПараметр("БезОтбораПоВключениюНДСВЦену", 
				?(БезОтбораПоВключениюНДСВЦену = Неопределено, Ложь, БезОтбораПоВключениюНДСВЦену));
	
	Элементы.ВидЦены.СписокВыбора.Очистить();
	Элементы.ВидЦены.СписокВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидЦен"));
	Элементы.ВидЦены.СписокВыбора.Добавить(Справочники.ВидыЦен.ПустаяСсылка(), НСтр("ru='<произвольная>';uk='<довільна>'"));
	
	Элементы.Цена.ТолькоПросмотр = ЗначениеЗаполнено(ВидЦены);
	Элементы.Цена.ПропускатьПриВводе = ЗначениеЗаполнено(ВидЦены);
	
	// Настроить видимость и установить значения реквизитов для редактирования ручных скидок, наценок.
	СуммаДокумента = КоличествоУпаковок * Цена;
	
	Если Не Параметры.ИспользоватьРучныеСкидкиВПродажах Или Параметры.СкрыватьРучныеСкидки Тогда
		
		Элементы.ГруппаПараметрыСкидкиНаценки.Видимость = Ложь;
		
	Иначе
		
		// Установить свойства элементов относящихся к скидкам (наценкам).
		ИспользоватьОграниченияРучныхСкидок = (ПолучитьФункциональнуюОпцию("ИспользоватьОграниченияРучныхСкидокВПродажахПоПользователям")
		                                      Или ПолучитьФункциональнуюОпцию("ИспользоватьОграниченияРучныхСкидокВПродажахПоСоглашениям"));
		
		Если ИспользоватьОграниченияРучныхСкидок Тогда
			
			СтруктураТаблиц = ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище);
			
			МаксимальныйПроцентСкидки  = СтруктураТаблиц.Ограничения[0].МаксимальныйПроцентРучнойСкидки;
			МаксимальныйПроцентНаценки = СтруктураТаблиц.Ограничения[0].МаксимальныйПроцентРучнойНаценки;
			
			Если МаксимальныйПроцентСкидки > 0 Тогда
				Элементы.ПроцентСкидки.КнопкаСпискаВыбора = Истина;
				Элементы.ПроцентСкидки.СписокВыбора.Добавить(МаксимальныйПроцентСкидки, Формат(МаксимальныйПроцентСкидки, "ЧЦ=15; ЧДЦ=2"));
			КонецЕсли;
			
			Если МаксимальныйПроцентНаценки > 0 Тогда
				Элементы.ПроцентНаценки.КнопкаСпискаВыбора = Истина;
				Элементы.ПроцентНаценки.СписокВыбора.Добавить(МаксимальныйПроцентНаценки, Формат(МаксимальныйПроцентНаценки, "ЧЦ=15; ЧДЦ=2"));
			КонецЕсли;
			
		КонецЕсли;
		
		Элементы.НадписьМаксимальнаяРучнаяСкидка.Видимость  = ИспользоватьОграниченияРучныхСкидок;
		Элементы.НадписьМаксимальнаяРучнаяСкидка.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Макс. скидка: %1%2';uk='Макс. знижка: %1%2'"),
			МаксимальныйПроцентСкидки,
			"%");
		
		Элементы.НадписьМаксимальнаяРучнаяНаценка.Видимость = ИспользоватьОграниченияРучныхСкидок;
		Элементы.НадписьМаксимальнаяРучнаяНаценка.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Макс. наценка: %1%2';uk='Макс. націнка: %1%2'"),
			МаксимальныйПроцентНаценки,
			"%");
		
		Элементы.НадписьМаксимальнаяСкидкаНеОграничена.Видимость   = Не ИспользоватьОграниченияРучныхСкидок;
		Элементы.НадписьМаксимальнаяНаценкаНеОграничена.Видимость  = Не ИспользоватьОграниченияРучныхСкидок;
		
		// Установить варианты выбора ручной скидки (наценки).
		Элементы.ВариантПредоставления.СписокВыбора.Добавить(1, НСтр("ru='Скидка';uk='Знижка'"));
		Элементы.ВариантПредоставления.СписокВыбора.Добавить(2, НСтр("ru='Наценка';uk='Націнка'"));
		
		// Установить значение варианта предоставления при открытии.
		ВариантПредоставления = 1; // Скидка
		Элементы.ВариантыПредоставления.ТекущаяСтраница = Элементы.ВариантыПредоставления.ПодчиненныеЭлементы.Скидка;
		
	КонецЕсли;
	
 	УстановитьВидимостьКоличествоЕдиницХранения();

	ОбновитьКоличетсво();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УпаковкаПриИзменении(Элемент)
	
	УпаковкаПриИзмененииНаСервере(СтараяУпаковка);
	СтараяУпаковка = Упаковка;
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковкаОчистка(Элемент, СтандартнаяОбработка)
	
	УпаковкаПриИзмененииНаСервере(СтараяУпаковка);
	СтараяУпаковка = Упаковка;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЦеныПриИзменении(Элемент)
	
	ВидЦеныПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенаПриИзменении(Элемент)
	
	ВидЦены = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПредоставленияПриИзменении(Элемент)
	
	Если ВариантПредоставления = 1 Тогда
		Элементы.ВариантыПредоставления.ТекущаяСтраница = Элементы.ВариантыПредоставления.ПодчиненныеЭлементы.Скидка;
	Иначе
		Элементы.ВариантыПредоставления.ТекущаяСтраница = Элементы.ВариантыПредоставления.ПодчиненныеЭлементы.Наценка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоУпаковокПриИзменении(Элемент)
	
	ОбновитьКоличетсво();
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	ОбновитьКоличетсвоУпаковок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Отказ = Ложь;
	ОчиститьСообщения();
	
	Если КоличествоУпаковок = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнено количество';uk='Не заповнена кількість'"),,"КоличествоУпаковок",,Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПодобранныеТовары = Новый Массив;
	
	ПараметрыТовара = Новый Структура;
	ПараметрыТовара.Вставить("Номенклатура", Номенклатура);        
	ПараметрыТовара.Вставить("Характеристика", Характеристика);
	ПараметрыТовара.Вставить("Упаковка", Упаковка);
	ПараметрыТовара.Вставить("Цена", Цена);
	ПараметрыТовара.Вставить("ВидЦены", ВидЦены);
	ПараметрыТовара.Вставить("КоличествоУпаковок", КоличествоУпаковок);
	ПараметрыТовара.Вставить("Склад", Склад);
	ПараметрыТовара.Вставить("ДатаОтгрузки", ДатаОтгрузки);
			
	Если ВариантПредоставления = 1 Тогда
		ПараметрыТовара.Вставить("ПроцентРучнойСкидки", ПроцентРучнойСкидкиНаценки);
	Иначе
		ПараметрыТовара.Вставить("ПроцентРучнойСкидки", -ПроцентРучнойСкидкиНаценки);
	КонецЕсли;
	
	ПодобранныеТовары.Добавить(ПараметрыТовара);
	
	Закрыть(ПодобранныеТовары);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Округлить(Команда)
	
	Количество = Окр(Количество, 0, РежимОкругления.Окр15как20);
	ОбновитьКоличетсвоУпаковок();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПроцентСкидки.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПроцентРучнойСкидкиНаценки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("МаксимальныйПроцентСкидки");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьОграниченияРучныхСкидок");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПроцентНаценки.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПроцентРучнойСкидкиНаценки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("МаксимальныйПроцентНаценки");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьОграниченияРучныхСкидок");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НоменклатураЕдиницаИзмерения.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Количество.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УказаноДробноеКоличествоВБазовыхЕдиницах");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);

КонецПроцедуры

&НаСервере
Процедура УпаковкаПриИзмененииНаСервере(СтараяУпаковка)
	
	УстановитьВидимостьКоличествоЕдиницХранения();
	ОбновитьКоличетсво();
	
	Цена = Цена * 
		Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Упаковка, Номенклатура) /
		Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(СтараяУпаковка, Номенклатура);
	
КонецПроцедуры

&НаСервере
Процедура ВидЦеныПриИзмененииНаСервере()
	
	Элементы.Цена.ТолькоПросмотр = ЗначениеЗаполнено(ВидЦены);
	Элементы.Цена.ПропускатьПриВводе = ЗначениеЗаполнено(ВидЦены);
	
	Если Не ЗначениеЗаполнено(ВидЦены) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫРАЗИТЬ(ЦеныНоменклатурыСрезПоследних.Цена * КурсыСрезПоследних.Курс / КурсыСрезПоследних.Кратность / КурсыСрезПоследнихВалютаЦены.Курс * КурсыСрезПоследнихВалютаЦены.Кратность * ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) КАК ЧИСЛО(15, 2)) КАК Цена
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			КОНЕЦПЕРИОДА(&Дата, ДЕНЬ),
	|			Номенклатура = &Номенклатура
	|				И Характеристика = &Характеристика
	|				И ВидЦены = &ВидЦены) КАК ЦеныНоменклатурыСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Дата, ) КАК КурсыСрезПоследних
	|		ПО (КурсыСрезПоследних.Валюта = ЦеныНоменклатурыСрезПоследних.Валюта)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта) КАК КурсыСрезПоследнихВалютаЦены
	|		ПО (ИСТИНА)");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ВЫРАЗИТЬ(&Упаковка КАК Справочник.УпаковкиЕдиницыИзмерения)", Неопределено));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ЦеныНоменклатурыСрезПоследних.Упаковка",
			"ЦеныНоменклатурыСрезПоследних.Номенклатура"));
			
	Запрос.УстановитьПараметр("ВидЦены",        ВидЦены);
	Запрос.УстановитьПараметр("Дата",           Дата);
	Запрос.УстановитьПараметр("Номенклатура",   Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	Запрос.УстановитьПараметр("Упаковка",       Упаковка);
	Запрос.УстановитьПараметр("Валюта",         Валюта);
	
	Цена = 0;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если ЗначениеЗаполнено(Выборка.Цена) Тогда
			Цена = Выборка.Цена;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоличетсво()
	
	Количество = КоличествоУпаковок*Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Упаковка, Номенклатура);
	УстановитьВидимостьОкруглить();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоличетсвоУпаковок()
	
	КоличествоУпаковок = Количество/Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Упаковка, Номенклатура);
	УстановитьВидимостьОкруглить();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКоличествоЕдиницХранения()
	
	ЕдиницаИзмеренияТипИзмеряемойВеличины = "";
	УпаковкаТипИзмеряемойВеличины = "";
	
	ЕдиницаМерная = Справочники.УпаковкиЕдиницыИзмерения.ЭтоМернаяЕдиница(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ЕдиницаИзмерения"),
																			ЕдиницаИзмеренияТипИзмеряемойВеличины);
																			
	УпаковкаМерная = Справочники.УпаковкиЕдиницыИзмерения.ЭтоМернаяЕдиница(Упаковка,
																			УпаковкаТипИзмеряемойВеличины);
	Если ЕдиницаМерная
		И УпаковкаТипИзмеряемойВеличины <> ЕдиницаИзмеренияТипИзмеряемойВеличины
		И УпаковкаТипИзмеряемойВеличины <> "Упаковка"
		И УпаковкаТипИзмеряемойВеличины <> ""
		Или ЕдиницаИзмеренияТипИзмеряемойВеличины = "КоличествоШтук" 
		И УпаковкаМерная Тогда 
		
		Элементы.Количество.Видимость = Истина;
		Элементы.НоменклатураЕдиницаИзмерения.Видимость = Истина;
		Элементы.ДекорацияКоличествоОкруглить.Видимость = Ложь;
		
	Иначе
		
		Элементы.Количество.Видимость = Ложь;
		Элементы.НоменклатураЕдиницаИзмерения.Видимость = Ложь;
		Элементы.ДекорацияКоличествоОкруглить.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьОкруглить()
	
	Если Количество <> Цел(Количество) И Элементы.Количество.Видимость И Не ЕдиницаМерная Тогда
		УказаноДробноеКоличествоВБазовыхЕдиницах = Истина;
		Элементы.Округлить.Видимость = Истина;
	Иначе
		УказаноДробноеКоличествоВБазовыхЕдиницах = Ложь;
		Элементы.Округлить.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
