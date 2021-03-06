
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры,,
	                        "ЗакрыватьПриВыборе, ЗакрыватьПриЗакрытииВладельца, ТолькоПросмотр");
	
	Период = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("РаботаСАктамиРасхождений.ФормаПодбораДокументовОснований", 
	                                                          "ПериодПодбораОснованийАктОРасхожденияПослеОтгрузки");
	Если Период.ДатаОкончания = Дата(1, 1, 1) И Период.ДатаОкончания = Дата(1, 1, 1) Тогда
		Период.Вариант = ВариантСтандартногоПериода.Месяц;
	КонецЕсли;
	
	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		Элементы.ИнформационнаяНадписьОтборы.Высота = 1;
	КонецЕсли;
	
	ЗаполнитьТаблицуДокументовОснований();
	СформироватьИнформационнуюНадписьОтборы();
	СформироватьИнформационнуюНадписьКоличествоДокументов(ЭтаФорма);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("РаботаСАктамиРасхождений.ФормаПодбораДокументовОснований",
	                                                 "ПериодПодбораОснованийАктОРасхожденияПослеОтгрузки",
	                                                 Период);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки <> Неопределено Тогда
		Настройки.Удалить("Период");
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И НЕ ПеренестиВДокумент Тогда
		
		ЕстьИзменения = Ложь;
		
		ВыбранныеСтроки = Основания.НайтиСтроки(Новый Структура("Выбран", Истина));
		Если ВыбранныеСтроки.Количество() <> ДокументыОснования.Количество() Тогда
			ЕстьИзменения = Истина;
		ИначеЕсли ВыбранныеСтроки.Количество() = 0 ИЛИ ДокументыОснования.Количество() = 0 Тогда
			
			ЕстьИзменения = Истина;
			
		Иначе
			Для Каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
				Если ДокументыОснования.НайтиПоЗначению(ВыбраннаяСтрока.Ссылка) = Неопределено Тогда
					ЕстьИзменения = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ЕстьИзменения Тогда
			ТекстВопроса = НСтр("ru='Состав документов-оснований был изменен. Принять изменения?';uk='Склад документів-підстав був змінений. Прийняти зміни?'");
			ОбработчикОповещения = Новый ОписаниеОповещения("ВопросОПринятииИзмененийПриОтвете", ЭтаФорма);
			ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
			Отказ = Истина;
		КонецЕсли;
		
	ИначеЕсли ПеренестиВДокумент  Тогда
		
		Если Не ОчисткаПодтверждена И ТабличнаяЧастьНеПустая Тогда
			ТекстВопроса = НСтр("ru='Табличная часть документа будет очищена и перезаполнена. Продолжить?';uk='Таблична частина документа буде очищена і перезаполнена. Продовжити?'");
			ОбработчикОповещения = Новый ОписаниеОповещения("ВопросООчисткеТабличнойЧастиПриОтвете", ЭтаФорма);
			ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			Отказ = Истина;
		Иначе
			
			ПеренестиВДокумент();
			Отказ = Истина;
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодВариантПриИзменении(Элемент)
	
	ЗаполнитьТаблицуДокументовОснований();
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийТабличнойЧастиРеализации

&НаКлиенте
Процедура РеализацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока <> Неопределено Тогда
		ПоказатьЗначение(, Основания.НайтиПоИдентификатору(ВыбраннаяСтрока).Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеализацииВыбранПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Реализации.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗнакОперации = ?(ТекущиеДанные.Выбран,1,-1);
	КоличествоДокументов = КоличествоДокументов + 1*ЗнакОперации;
	ДокументыНаСумму     = ДокументыНаСумму + ТекущиеДанные.СуммаДокумента*ЗнакОперации;
	
	ВывестиИнформационнуюНадписьКоличествоДокументов(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьТаблицуДокументовОснований();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВсе(Команда)
	
	УстановитьФлагиВыбрано(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	
	УстановитьФлагиВыбрано(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()
	
	ПеренестиВДокумент = Истина;
	Закрыть(КодВозвратаДиалога.OK);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьТаблицуДокументовОснований()
	
	ТаблицаОснованийДокумента = Новый ТаблицаЗначений;
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ОснованияДокумента.Реализация
	|ПОМЕСТИТЬ ВыбранныеДокументы
	|ИЗ
	|	&ОснованияДокумента КАК ОснованияДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////";

	
	Если РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(ТипОснованияАктаОРасхождении) Тогда
		
		ТаблицаОснованийДокумента.Колонки.Добавить("Реализация", Новый ОписаниеТипов("ДокументСсылка.РеализацияТоваровУслуг"));
		
		Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫБОР
		|		КОГДА ВыбранныеДокументы.Реализация ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Выбран,
		|	РеализацияТоваровУслуг.Номер,
		|	РеализацияТоваровУслуг.Дата,
		|	РеализацияТоваровУслуг.СуммаДокумента,
		|	РеализацияТоваровУслуг.Ссылка
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВыбранныеДокументы КАК ВыбранныеДокументы
		|		ПО РеализацияТоваровУслуг.Ссылка = ВыбранныеДокументы.Реализация
		|ГДЕ
		|	ВЫБОР 
		|		КОГДА НЕ &ИспользоватьСоглашенияСКлиентами
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ РеализацияТоваровУслуг.Соглашение = &Соглашение
		|	КОНЕЦ
		|	И РеализацияТоваровУслуг.Контрагент = &Контрагент
		|	И РеализацияТоваровУслуг.Организация = &Организация
		|	И РеализацияТоваровУслуг.Партнер = &Партнер
		|	И РеализацияТоваровУслуг.Валюта = &Валюта
		|	И РеализацияТоваровУслуг.ЦенаВключаетНДС = &ЦенаВключаетНДС
		|	И РеализацияТоваровУслуг.ХозяйственнаяОперация = &ХозяйственнаяОперация
		|	И ВЫБОР
		|			КОГДА &УказаниеДоговораНеТребуется
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ РеализацияТоваровУслуг.Договор = &Договор
		|		КОНЕЦ
		|	И РеализацияТоваровУслуг.Проведен
		|	И РеализацияТоваровУслуг.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.Отгружено)
		|	И ВЫБОР
		|			КОГДА &ДатаНачала = &ПустаяДата
		|					И &ДатаОкончания = &ПустаяДата
		|				ТОГДА ИСТИНА
		|			КОГДА &ДатаНачала = &ПустаяДата
		|				ТОГДА РеализацияТоваровУслуг.Дата <= &ДатаОкончания
		|			КОГДА &ДатаОкончания = &ПустаяДата
		|				ТОГДА РеализацияТоваровУслуг.Дата >= &ДатаНачала
		|			ИНАЧЕ РеализацияТоваровУслуг.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	РеализацияТоваровУслуг.Дата УБЫВ";
		
		Запрос.УстановитьПараметр("ИспользоватьСоглашенияСКлиентами", ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами"));
		
	ИначеЕсли ТипОснованияАктаОРасхождении = Перечисления.ТипыОснованияАктаОРасхождении.ПоступлениеТоваровУслуг Тогда
		
		ТаблицаОснованийДокумента.Колонки.Добавить("Реализация", Новый ОписаниеТипов("ДокументСсылка.ПоступлениеТоваровУслуг"));
		
		Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫБОР
		|		КОГДА ВыбранныеДокументы.Реализация ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Выбран,
		|	ПоступлениеТоваровУслуг.Номер,
		|	ПоступлениеТоваровУслуг.Дата,
		|	ПоступлениеТоваровУслуг.СуммаДокумента,
		|	ПоступлениеТоваровУслуг.Ссылка
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВыбранныеДокументы КАК ВыбранныеДокументы
		|		ПО ПоступлениеТоваровУслуг.Ссылка = ВыбранныеДокументы.Реализация
		|ГДЕ
		|	ВЫБОР 
		|		КОГДА НЕ &ИспользоватьСоглашенияСКлиентами
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ПоступлениеТоваровУслуг.Соглашение = &Соглашение
		|	КОНЕЦ
		|	И ПоступлениеТоваровУслуг.Контрагент = &Контрагент
		|	И ПоступлениеТоваровУслуг.Организация = &Организация
		|	И ПоступлениеТоваровУслуг.Партнер = &Партнер
		|	И ПоступлениеТоваровУслуг.Валюта = &Валюта
		|	И ПоступлениеТоваровУслуг.ЦенаВключаетНДС = &ЦенаВключаетНДС
		|	И ПоступлениеТоваровУслуг.ХозяйственнаяОперация = &ХозяйственнаяОперация
		|	И ВЫБОР
		|			КОГДА &УказаниеДоговораНеТребуется
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ПоступлениеТоваровУслуг.Договор = &Договор
		|		КОНЕЦ
		|	И ПоступлениеТоваровУслуг.Проведен
		|	И ВЫБОР
		|			КОГДА &ДатаНачала = &ПустаяДата
		|					И &ДатаОкончания = &ПустаяДата
		|				ТОГДА ИСТИНА
		|			КОГДА &ДатаНачала = &ПустаяДата
		|				ТОГДА ПоступлениеТоваровУслуг.Дата <= &ДатаОкончания
		|			КОГДА &ДатаОкончания = &ПустаяДата
		|				ТОГДА ПоступлениеТоваровУслуг.Дата >= &ДатаНачала
		|			ИНАЧЕ ПоступлениеТоваровУслуг.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПоступлениеТоваровУслуг.Дата УБЫВ";
		
		Запрос.УстановитьПараметр("ИспользоватьСоглашенияСКлиентами", ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами"));
	
		
	ИначеЕсли ТипОснованияАктаОРасхождении = Перечисления.ТипыОснованияАктаОРасхождении.ВозвратТоваровОтКлиента Тогда
		
		ТаблицаОснованийДокумента.Колонки.Добавить("Реализация", Новый ОписаниеТипов("ДокументСсылка.ВозвратТоваровОтКлиента"));
		
		Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫБОР
		|		КОГДА ВыбранныеДокументы.Реализация ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Выбран,
		|	ВозвратТоваровОтКлиента.Номер,
		|	ВозвратТоваровОтКлиента.Дата,
		|	ВозвратТоваровОтКлиента.СуммаДокумента,
		|	ВозвратТоваровОтКлиента.Ссылка
		|ИЗ
		|	Документ.ВозвратТоваровОтКлиента КАК ВозвратТоваровОтКлиента
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВыбранныеДокументы КАК ВыбранныеДокументы
		|		ПО ВозвратТоваровОтКлиента.Ссылка = ВыбранныеДокументы.Реализация
		|ГДЕ
		|	ВЫБОР 
		|		КОГДА НЕ &ИспользоватьСоглашенияСПоставщиками
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ВозвратТоваровОтКлиента.Соглашение = &Соглашение
		|	КОНЕЦ
		|	И ВозвратТоваровОтКлиента.Контрагент = &Контрагент
		|	И ВозвратТоваровОтКлиента.Организация = &Организация
		|	И ВозвратТоваровОтКлиента.Партнер = &Партнер
		|	И ВозвратТоваровОтКлиента.Валюта = &Валюта
		|	И ВозвратТоваровОтКлиента.ЦенаВключаетНДС = &ЦенаВключаетНДС
		|	И ВозвратТоваровОтКлиента.ХозяйственнаяОперация = &ХозяйственнаяОперация
		|	И ВЫБОР
		|			КОГДА &УказаниеДоговораНеТребуется
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ВозвратТоваровОтКлиента.Договор = &Договор
		|		КОНЕЦ
		|	И ВозвратТоваровОтКлиента.Проведен
		|	И ВЫБОР
		|			КОГДА &ДатаНачала = &ПустаяДата
		|					И &ДатаОкончания = &ПустаяДата
		|				ТОГДА ИСТИНА
		|			КОГДА &ДатаНачала = &ПустаяДата
		|				ТОГДА ВозвратТоваровОтКлиента.Дата <= &ДатаОкончания
		|			КОГДА &ДатаОкончания = &ПустаяДата
		|				ТОГДА ВозвратТоваровОтКлиента.Дата >= &ДатаНачала
		|			ИНАЧЕ ВозвратТоваровОтКлиента.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВозвратТоваровОтКлиента.Дата УБЫВ";
		
	Иначе
		
		ТаблицаОснованийДокумента.Колонки.Добавить("Реализация", Новый ОписаниеТипов("ДокументСсылка.ВозвратТоваровПоставщику"));
		
		Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫБОР
		|		КОГДА ВыбранныеДокументы.Реализация ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Выбран,
		|	ВозвратТоваровПоставщику.Номер,
		|	ВозвратТоваровПоставщику.Дата,
		|	ВозвратТоваровПоставщику.СуммаДокумента,
		|	ВозвратТоваровПоставщику.Ссылка
		|ИЗ
		|	Документ.ВозвратТоваровПоставщику КАК ВозвратТоваровПоставщику
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВыбранныеДокументы КАК ВыбранныеДокументы
		|		ПО ВозвратТоваровПоставщику.Ссылка = ВыбранныеДокументы.Реализация
		|ГДЕ
		|	ВЫБОР 
		|		КОГДА НЕ &ИспользоватьСоглашенияСПоставщиками
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ВозвратТоваровПоставщику.Соглашение = &Соглашение
		|	КОНЕЦ
		|	И ВозвратТоваровПоставщику.Контрагент = &Контрагент
		|	И ВозвратТоваровПоставщику.Организация = &Организация
		|	И ВозвратТоваровПоставщику.Партнер = &Партнер
		|	И ВозвратТоваровПоставщику.Валюта = &Валюта
		|	И ВозвратТоваровПоставщику.ЦенаВключаетНДС = &ЦенаВключаетНДС
		|	И ВозвратТоваровПоставщику.ХозяйственнаяОперация = &ХозяйственнаяОперация
		|	И ВЫБОР
		|			КОГДА &УказаниеДоговораНеТребуется
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ВозвратТоваровПоставщику.Договор = &Договор
		|		КОНЕЦ
		|	И ВозвратТоваровПоставщику.Проведен
		|	И ВЫБОР
		|			КОГДА &ДатаНачала = &ПустаяДата
		|					И &ДатаОкончания = &ПустаяДата
		|				ТОГДА ИСТИНА
		|			КОГДА &ДатаНачала = &ПустаяДата
		|				ТОГДА ВозвратТоваровПоставщику.Дата <= &ДатаОкончания
		|			КОГДА &ДатаОкончания = &ПустаяДата
		|				ТОГДА ВозвратТоваровПоставщику.Дата >= &ДатаНачала
		|			ИНАЧЕ ВозвратТоваровПоставщику.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВозвратТоваровПоставщику.Дата УБЫВ";
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("УказаниеДоговораНеТребуется", УказаниеДоговораНеТребуется);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("ДокументыОснования", ДокументыОснования);
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ЦенаВключаетНДС", ЦенаВключаетНДС);
	Запрос.УстановитьПараметр("ДатаНачала", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("ИспользоватьСоглашенияСПоставщиками", ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСПоставщиками"));
	Запрос.УстановитьПараметр("ИспользоватьСоглашенияСКлиентами", ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами"));
	Запрос.УстановитьПараметр("ПустаяДата", Дата(1, 1, 1));

	Для Каждого ЭлементСписка Из ДокументыОснования Цикл
		НоваяСтрока = ТаблицаОснованийДокумента.Добавить();
		НоваяСтрока.Реализация = ЭлементСписка.Значение;
	КонецЦикла;
	Запрос.УстановитьПараметр("ОснованияДокумента", ТаблицаОснованийДокумента);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Основания.Очистить();
	Иначе
		Основания.Загрузить(Результат.Выгрузить());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОПринятииИзмененийПриОтвете(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросООчисткеТабличнойЧастиПриОтвете(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ПеренестиВДокумент();
		
	Иначе
		
		ПеренестиВДокумент = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент()
	
	МассивВыбранныхДокументов = Новый Массив;
	ВыбранныеСтроки = Основания.НайтиСтроки(Новый Структура("Выбран", Истина));
	Для Каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
		МассивВыбранныхДокументов.Добавить(ВыбраннаяСтрока.Ссылка);
	КонецЦикла;
	
	ОчисткаПодтверждена = Истина;
	ЗакрытьФорму = Истина;
	ОповеститьОВыборе(МассивВыбранныхДокументов);
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьФлагиВыбрано(Включать)

	Для Каждого СтрокаТаблицы Из Основания Цикл
		СтрокаТаблицы.Выбран = Включать;
	КонецЦикла;
	
	Если Включать Тогда
		СформироватьИнформационнуюНадписьКоличествоДокументов(ЭтаФорма)
	Иначе
		КоличествоДокументов = 0;
		ДокументыНаСумму     = 0;
		ВывестиИнформационнуюНадписьКоличествоДокументов(ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СформироватьИнформационнуюНадписьОтборы()
	
	
	Если НЕ ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		ИнформационнаяНадписьОтборы = НСтр("ru='Отбор по: %Организация%, %Партнер%,%Контрагент% %Валюта%, %Соглашение%, %НалогообложениеНДС%,%Договор%%ХозяйственнаяОперация%, %ЦенаВключаетНДС%';uk='Відбір за: %Организация%, %Партнер%,%Контрагент% %Валюта%, %Соглашение%, %НалогообложениеНДС%,%Договор%%ХозяйственнаяОперация%, %ЦенаВключаетНДС%'");
	Иначе
		ИнформационнаяНадписьОтборы = НСтр("ru='Отбор по: %Контрагент%%Договор%%Соглашение%';uk='Відбір за: %Контрагент%%Договор%%Соглашение%'");
	КонецЕсли;
	
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%Организация%", Организация);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%Партнер%", Партнер);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%Контрагент%", ?(ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов"),""," " + Контрагент  + ", "));
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%Соглашение%", Соглашение);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%Валюта%", Валюта);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%НалогообложениеНДС%", НалогообложениеНДС);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%Договор%", ?(УказаниеДоговораНеТребуется,""," " + Договор + ", "));
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%ХозяйственнаяОперация%", ХозяйственнаяОперация);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы,"%ЦенаВключаетНДС%", ?(ЦенаВключаетНДС, НСтр("ru='Цена включает НДС';uk='Ціна включає ПДВ'"), НСтр("ru='Цена не включает НДС';uk='Ціна не включає ПДВ'")));
	
	Если Прав(ИнформационнаяНадписьОтборы,2) = ", " Тогда
		ИнформационнаяНадписьОтборы = Лев(ИнформационнаяНадписьОтборы, СтрДлина(ИнформационнаяНадписьОтборы) - 2);
	КонецЕсли;
	
	ИнформационнаяНадписьОтборы = ИнформационнаяНадписьОтборы + ".";
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьИнформационнуюНадписьКоличествоДокументов(Форма)

	Форма.КоличествоДокументов = 0;
	Форма.ДокументыНаСумму     = 0;
	
	Для Каждого СтрокаТаблицы Из Форма.Основания Цикл
		Если СтрокаТаблицы.Выбран Тогда
			Форма.КоличествоДокументов = Форма.КоличествоДокументов + 1;
			Форма.ДокументыНаСумму     = Форма.ДокументыНаСумму + СтрокаТаблицы.СуммаДокумента;
		КонецЕсли;
	КонецЦикла;
	
	ВывестиИнформационнуюНадписьКоличествоДокументов(Форма);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ВывестиИнформационнуюНадписьКоличествоДокументов(Форма)

	Если Форма.КоличествоДокументов <> 0 Тогда
		ТекстНадписи = НСтр("ru='Подобрано документов - %КоличествоДокументов%, на сумму %ДокументыНаСумму% %Валюта%.';uk='Підібрано документів - %КоличествоДокументов%, на суму %ДокументыНаСумму% %Валюта%.'");
		ТекстНадписи = СтрЗаменить(ТекстНадписи,"%КоличествоДокументов%", Форма.КоличествоДокументов);
		ТекстНадписи = СтрЗаменить(ТекстНадписи,"%ДокументыНаСумму%", Форма.ДокументыНаСумму);
		ТекстНадписи = СтрЗаменить(ТекстНадписи,"%Валюта%", Форма.Валюта);
	Иначе
		ТекстНадписи = НСтр("ru='Подобрано 0 документов.';uk='Підібрано 0 документів.'");
	КонецЕсли;
	
	Форма.ИнформационнаяНадписьКоличествоДокументов = ТекстНадписи;

КонецПроцедуры

#КонецОбласти

