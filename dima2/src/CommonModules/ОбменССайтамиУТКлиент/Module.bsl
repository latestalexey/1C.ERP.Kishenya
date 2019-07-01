
// Меняет заголовок формы в зависимости от флага "КлассифицироватьПоВидамноменклатуры"
//
Процедура УстановитьПараметрыТаблицыКаталогов(Форма) Экспорт
	
	Если Форма.КлассифицироватьПоВидамНоменклатуры Тогда
		
		ЗаголовокТаблицы = НСтр("ru='Таблица каталогов (соответствие видов номенклатуры каталогам на сайте)';uk='Таблиця каталогів (відповідність видів номенклатури каталогам на сайті)'");
		ЗаголовокКолонки = НСтр("ru='Виды номенклатуры';uk='Види номенклатури'");
		ВыборГруппИЭлементов = ГруппыИЭлементы.ГруппыИЭлементы;
		
	Иначе
		
		ЗаголовокТаблицы = НСтр("ru='Таблица каталогов (соответствие групп номенклатуры каталогам на сайте)';uk='Таблиця каталогів (відповідність груп номенклатури каталогам на сайті)'");
		ЗаголовокКолонки = НСтр("ru='Группы номенклатуры';uk='Групи номенклатури'");
		ВыборГруппИЭлементов = ГруппыИЭлементы.Группы;
		
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	Элементы.ГруппаТаблицаКаталогов.Заголовок = ЗаголовокТаблицы;
	Элементы.ТаблицаКаталоговГруппы.Заголовок = ЗаголовокКолонки;
	Элементы.ТаблицаКаталоговГруппы.ВыборГруппИЭлементов = ВыборГруппИЭлементов;
	
КонецПроцедуры

// Меняет тип значения колонки "Группы" таблицы каталогов товаров в зависимости от флага "КлассифицироватьПоВидамноменклатуры"
//
Процедура ИзменитьТипЗначенийСпискаГруппТаблицыКаталогов(Форма) Экспорт
	
	Если Форма.КлассифицироватьПоВидамНоменклатуры Тогда 
		
		ТипЗначений = Новый ОписаниеТипов("СправочникСсылка.ВидыНоменклатуры");
		
	Иначе
		
		ТипЗначений = Новый ОписаниеТипов("СправочникСсылка.Номенклатура");
		
	КонецЕсли;
	
	ТаблицаКаталогов = Форма.ТаблицаКаталогов;
	НадписьВсеГруппы = "(" + НСтр("ru='Все';uk='Всі'") + ")";
	
	Для Каждого СтрокаТаблицыКаталогов Из ТаблицаКаталогов Цикл
		
		СтрокаТаблицыКаталогов.Группы.ТипЗначения = ТипЗначений;
		СтрокаТаблицыКаталогов.Группы.Очистить();
		СтрокаТаблицыКаталогов.Группы.Добавить(НеОпределено, НадписьВсеГруппы);
		
	КонецЦикла;
	
КонецПроцедуры

