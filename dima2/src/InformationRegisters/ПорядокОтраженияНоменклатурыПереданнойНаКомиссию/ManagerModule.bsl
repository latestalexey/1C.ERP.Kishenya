#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция РезультатЗапросаПоНастройкамОтраженияВУчете(МассивОрганизаций, Период) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Организация КАК Организация,
	|	ВложенныйЗапрос.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	МАКСИМУМ(ВложенныйЗапрос.ЕстьПродажаСобственныхТоваров) КАК ЕстьПродажаСобственныхТоваров
	|ПОМЕСТИТЬ ДвиженияНоменклатуры
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ДанныеРегистра.Организация КАК Организация,
	|		(ВЫБОР
	|			КОГДА НЕ &ФормироватьВидыЗапасовПоГруппамФинансовогоУчета
	|				ТОГДА НоменклатураСпр.ГруппаФинансовогоУчета
	|			ИНАЧЕ 
	|				ЕСТЬNULL(ВидыЗапасовСпр.ГруппаФинансовогоУчета, ЗНАЧЕНИЕ(Справочник.ГруппыФинансовогоУчетаНоменклатуры.ПустаяСсылка))
	|		КОНЕЦ) КАК ГруппаФинансовогоУчета,
	|		Ложь КАК ЕстьПродажаСобственныхТоваров
	|	
	|	ИЗ
	|		РегистрНакопления.ТоварыПереданныеНаКомиссию.ОстаткиИОбороты(&ДатаНачала, &ДатаОкончания, Период,,
	|			ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|			И Организация В (&МассивОрганизаций)
	|		) КАК ДанныеРегистра
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|			ПО Аналитика.КлючАналитики = ДанныеРегистра.АналитикаУчетаНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК НоменклатураСпр
	|			ПО НоменклатураСпр.Ссылка = Аналитика.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК ВидыЗапасовСпр
	|			ПО ВидыЗапасовСпр.Ссылка = ДанныеРегистра.ВидЗапасов
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		Выручка.Организация КАК Организация,
	|		(ВЫБОР
	|			КОГДА НЕ &ФормироватьВидыЗапасовПоГруппамФинансовогоУчета 
	|				ТОГДА НоменклатураСпр.ГруппаФинансовогоУчета
	|			ИНАЧЕ 
	|				ЕСТЬNULL(ВидыЗапасовСпр.ГруппаФинансовогоУчета, ЗНАЧЕНИЕ(Справочник.ГруппыФинансовогоУчетаНоменклатуры.ПустаяСсылка))
	|			КОНЕЦ) КАК ГруппаФинансовогоУчета,
	|		Истина КАК ЕстьПродажаСобственныхТоваров
	|	ИЗ (
	|		ВЫБРАТЬ
	|			Выручка.ТипЗапасов,
	|			Выручка.ВидЗапасов,
	|			КлючиПартнеров.Организация,
	|			КлючиНоменклатуры.Номенклатура,
	|			КОЛИЧЕСТВО(*) как КоличествоЗаписей
	|		ИЗ (
	|			ВЫБРАТЬ
	|				Выручка.ТипЗапасов КАК ТипЗапасов,
	|				Выручка.ВидЗапасов КАК ВидЗапасов,
	|				Выручка.АналитикаУчетаНоменклатуры КАК КлючНоменклатуры,
	|				Выручка.АналитикаУчетаПоПартнерам КАК КлючПартнера,
	|				КОЛИЧЕСТВО(*) КАК КоличествоЗаписей
	|			ИЗ
	|				РегистрНакопления.ВыручкаИСебестоимостьПродаж КАК Выручка
	|			ГДЕ
	|				Выручка.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|
	|			СГРУППИРОВАТЬ ПО
	|				Выручка.ТипЗапасов,
	|				Выручка.ВидЗапасов,
	|				Выручка.АналитикаУчетаНоменклатуры,
	|				Выручка.АналитикаУчетаПоПартнерам
	|			) КАК Выручка
	|
	|			ЛЕВОЕ СОЕДИНЕНИЕ
	|				РегистрСведений.АналитикаУчетаПоПартнерам КАК КлючиПартнеров
	|			ПО
	|				КлючиПартнеров.КлючАналитики = Выручка.КлючПартнера
	|
	|			ЛЕВОЕ СОЕДИНЕНИЕ
	|				РегистрСведений.АналитикаУчетаНоменклатуры КАК КлючиНоменклатуры
	|			ПО
	|				КлючиНоменклатуры.КлючАналитики = Выручка.КлючНоменклатуры
	|		ГДЕ
	|			КлючиПартнеров.Организация В (&МассивОрганизаций)
	|			И (ТИПЗНАЧЕНИЯ(КлючиНоменклатуры.Склад) = ТИП(Справочник.Партнеры)
	|				ИЛИ ТИПЗНАЧЕНИЯ(КлючиНоменклатуры.Склад) = ТИП(Справочник.Организации))
	|	
	|		СГРУППИРОВАТЬ ПО
	|			Выручка.ТипЗапасов,
	|			Выручка.ВидЗапасов,
	|			КлючиПартнеров.Организация,
	|			КлючиНоменклатуры.Номенклатура
	|		) КАК Выручка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК НоменклатураСпр
	|			ПО НоменклатураСпр.Ссылка = Выручка.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК ВидыЗапасовСпр
	|			ПО ВидыЗапасовСпр.Ссылка = Выручка.ВидЗапасов
	|	) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Организация,
	|	ВложенныйЗапрос.ГруппаФинансовогоУчета
	|;
	|
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДвиженияНоменклатуры.Организация КАК Организация,
	|	ДвиженияНоменклатуры.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	
	|	ДвиженияНоменклатуры.ЕстьПродажаСобственныхТоваров КАК ЕстьПродажаСобственныхТоваров,
	|	
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаПередачиНаКомиссию, &ПустойСчет) <> &ПустойСчет
	|			ТОГДА ПорядокОтражения.СчетУчетаПередачиНаКомиссию
	|		ИНАЧЕ ГруппыФинансовогоУчета.СчетУчетаПередачиНаКомиссию
	|	КОНЕЦ КАК СчетУчетаПередачиНаКомиссию,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаПередачиНаКомиссию, &ПустойСчет) = &ПустойСчет
	|				И ЕСТЬNULL(ГруппыФинансовогоУчета.СчетУчетаПередачиНаКомиссию, &ПустойСчет) <> &ПустойСчет 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СчетУчетаПередачиНаКомиссиюПоУмолчанию,
	|
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаВыручкиОтПродаж, &ПустойСчет) <> &ПустойСчет
	|			ТОГДА ПорядокОтражения.СчетУчетаВыручкиОтПродаж
	|		ИНАЧЕ ГруппыФинансовогоУчета.СчетУчетаВыручкиОтПродаж
	|	КОНЕЦ КАК СчетУчетаВыручкиОтПродаж,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаВыручкиОтПродаж, &ПустойСчет) = &ПустойСчет
	|				И ЕСТЬNULL(ГруппыФинансовогоУчета.СчетУчетаВыручкиОтПродаж, &ПустойСчет)  <> &ПустойСчет 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СчетУчетаВыручкиОтПродажПоУмолчанию,
	|	
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаСебестоимостиПродаж, &ПустойСчет) <> &ПустойСчет
	|			ТОГДА ПорядокОтражения.СчетУчетаСебестоимостиПродаж
	|		ИНАЧЕ ГруппыФинансовогоУчета.СчетУчетаСебестоимостиПродаж
	|	КОНЕЦ КАК СчетУчетаСебестоимостиПродаж,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаСебестоимостиПродаж, &ПустойСчет) = &ПустойСчет
	|				И ЕСТЬNULL(ГруппыФинансовогоУчета.СчетУчетаСебестоимостиПродаж, &ПустойСчет)  <> &ПустойСчет 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СчетУчетаСебестоимостиПродажПоУмолчанию,
	|
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаВычетовИзДоходов, &ПустойСчет) <> &ПустойСчет
	|			ТОГДА ПорядокОтражения.СчетУчетаВычетовИзДоходов
	|		ИНАЧЕ ГруппыФинансовогоУчета.СчетУчетаВычетовИзДоходов
	|	КОНЕЦ КАК СчетУчетаВычетовИзДоходов,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаВычетовИзДоходов, &ПустойСчет) = &ПустойСчет
	|				И ЕСТЬNULL(ГруппыФинансовогоУчета.СчетУчетаВычетовИзДоходов, &ПустойСчет)  <> &ПустойСчет 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СчетУчетаВычетовИзДоходовПоУмолчанию,
	|
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СтатьяЗатратРегл, &ПустаяСтатьяЗатрат) <> &ПустаяСтатьяЗатрат
	|			ТОГДА ПорядокОтражения.СтатьяЗатратРегл
	|		ИНАЧЕ ГруппыФинансовогоУчета.СтатьяЗатратРегл
	|	КОНЕЦ КАК СтатьяЗатратРегл,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СтатьяЗатратРегл, &ПустаяСтатьяЗатрат) = &ПустаяСтатьяЗатрат
	|				И ЕСТЬNULL(ГруппыФинансовогоУчета.СтатьяЗатратРегл, &ПустаяСтатьяЗатрат) <> &ПустаяСтатьяЗатрат
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СтатьяЗатратРеглПоУмолчанию,
	|
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СтатьяДоходовРегл, &ПустаяСтатья) <> &ПустаяСтатья
	|			ТОГДА ПорядокОтражения.СтатьяДоходовРегл
	|		ИНАЧЕ ГруппыФинансовогоУчета.СтатьяДоходовРегл
	|	КОНЕЦ КАК СтатьяДоходовРегл,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СтатьяДоходовРегл, &ПустаяСтатья) = &ПустаяСтатья
	|				И ЕСТЬNULL(ГруппыФинансовогоУчета.СтатьяДоходовРегл, &ПустаяСтатья) <> &ПустаяСтатья
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СтатьяДоходовРеглПоУмолчанию
	|ИЗ
	|	ДвиженияНоменклатуры КАК ДвиженияНоменклатуры
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ПорядокОтраженияНоменклатурыПереданнойНаКомиссию КАК ПорядокОтражения
	|	ПО
	|		ДвиженияНоменклатуры.Организация = ПорядокОтражения.Организация
	|		И ДвиженияНоменклатуры.ГруппаФинансовогоУчета = ПорядокОтражения.ГруппаФинансовогоУчета
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.ГруппыФинансовогоУчетаНоменклатуры КАК ГруппыФинансовогоУчета
	|	ПО
	|		ДвиженияНоменклатуры.ГруппаФинансовогоУчета = ГруппыФинансовогоУчета.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПорядокОтражения.Организация КАК Организация,
	|	ПорядокОтражения.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|
	|	ЛОЖЬ КАК ЕстьПродажаСобственныхТоваров,
	|
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаПередачиНаКомиссию, &ПустойСчет) <> &ПустойСчет
	|			ТОГДА ПорядокОтражения.СчетУчетаПередачиНаКомиссию
	|		ИНАЧЕ ГруппыФинансовогоУчета.СчетУчетаПередачиНаКомиссию
	|	КОНЕЦ КАК СчетУчетаПередачиНаКомиссию,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаПередачиНаКомиссию, &ПустойСчет) = &ПустойСчет
	|				И ЕСТЬNULL(ГруппыФинансовогоУчета.СчетУчетаПередачиНаКомиссию, &ПустойСчет) <> &ПустойСчет 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СчетУчетаПередачиНаКомиссиюПоУмолчанию,
	|
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаВыручкиОтПродаж, &ПустойСчет) <> &ПустойСчет
	|			ТОГДА ПорядокОтражения.СчетУчетаВыручкиОтПродаж
	|		ИНАЧЕ ГруппыФинансовогоУчета.СчетУчетаВыручкиОтПродаж
	|	КОНЕЦ КАК СчетУчетаВыручкиОтПродаж,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаВыручкиОтПродаж, &ПустойСчет) = &ПустойСчет
	|				И ЕСТЬNULL(ГруппыФинансовогоУчета.СчетУчетаВыручкиОтПродаж, &ПустойСчет)  <> &ПустойСчет 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СчетУчетаВыручкиОтПродажПоУмолчанию,
	|	
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаСебестоимостиПродаж, &ПустойСчет) <> &ПустойСчет
	|			ТОГДА ПорядокОтражения.СчетУчетаСебестоимостиПродаж
	|		ИНАЧЕ ГруппыФинансовогоУчета.СчетУчетаСебестоимостиПродаж
	|	КОНЕЦ КАК СчетУчетаСебестоимостиПродаж,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаСебестоимостиПродаж, &ПустойСчет) = &ПустойСчет
	|				И ЕСТЬNULL(ГруппыФинансовогоУчета.СчетУчетаСебестоимостиПродаж, &ПустойСчет)  <> &ПустойСчет 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СчетУчетаСебестоимостиПродажПоУмолчанию,
	|
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаВычетовИзДоходов, &ПустойСчет) <> &ПустойСчет
	|			ТОГДА ПорядокОтражения.СчетУчетаВычетовИзДоходов
	|		ИНАЧЕ ГруппыФинансовогоУчета.СчетУчетаВычетовИзДоходов
	|	КОНЕЦ КАК СчетУчетаВычетовИзДоходов,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СчетУчетаВычетовИзДоходов, &ПустойСчет) = &ПустойСчет
	|				И ЕСТЬNULL(ГруппыФинансовогоУчета.СчетУчетаВычетовИзДоходов, &ПустойСчет)  <> &ПустойСчет 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СчетУчетаВычетовИзДоходовПоУмолчанию,
	|
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СтатьяЗатратРегл, &ПустаяСтатьяЗатрат) <> &ПустаяСтатьяЗатрат
	|			ТОГДА ПорядокОтражения.СтатьяЗатратРегл
	|		ИНАЧЕ ГруппыФинансовогоУчета.СтатьяЗатратРегл
	|	КОНЕЦ КАК СтатьяЗатратРегл,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СтатьяЗатратРегл, &ПустаяСтатьяЗатрат) = &ПустаяСтатьяЗатрат
	|				И ЕСТЬNULL(ГруппыФинансовогоУчета.СтатьяЗатратРегл, &ПустаяСтатьяЗатрат) <> &ПустаяСтатьяЗатрат
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СтатьяЗатратРеглПоУмолчанию,
	|
	|	
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СтатьяДоходовРегл, &ПустаяСтатья) <> &ПустаяСтатья
	|			ТОГДА ПорядокОтражения.СтатьяДоходовРегл
	|		ИНАЧЕ ГруппыФинансовогоУчета.СтатьяДоходовРегл
	|	КОНЕЦ КАК СтатьяДоходовРегл,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПорядокОтражения.СтатьяДоходовРегл, &ПустаяСтатья) = &ПустаяСтатья
	|				И ЕСТЬNULL(ГруппыФинансовогоУчета.СтатьяДоходовРегл, &ПустаяСтатья) <> &ПустаяСтатья
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СтатьяДоходовРеглПоУмолчанию
	|ИЗ
	|	РегистрСведений.ПорядокОтраженияНоменклатурыПереданнойНаКомиссию КАК ПорядокОтражения
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ДвиженияНоменклатуры КАК ДвиженияНоменклатуры
	|	ПО
	|		ПорядокОтражения.Организация = ДвиженияНоменклатуры.Организация
	|		И ПорядокОтражения.ГруппаФинансовогоУчета = ДвиженияНоменклатуры.ГруппаФинансовогоУчета
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.ГруппыФинансовогоУчетаНоменклатуры КАК ГруппыФинансовогоУчета
	|	ПО
	|		ПорядокОтражения.ГруппаФинансовогоУчета = ГруппыФинансовогоУчета.Ссылка
	|
	|ГДЕ
	|	ПорядокОтражения.Организация В (&МассивОрганизаций)
	|	И ДвиженияНоменклатуры.Организация ЕСТЬ NULL
	|	
	|УПОРЯДОЧИТЬ ПО
	|	Организация Возр,
	|	ГруппаФинансовогоУчета Возр
	|");
	Запрос.УстановитьПараметр("МассивОрганизаций", МассивОрганизаций);
	Запрос.УстановитьПараметр("ДатаНачала", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("ПустойСчет", ПланыСчетов.Хозрасчетный.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяСтатья", ПланыВидовХарактеристик.СтатьиДоходов.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяСтатьяЗатрат", ПланыВидовХарактеристик.СтатьиРасходов.ПустаяСсылка());
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоГруппамФинансовогоУчета",
		ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоГруппамФинансовогоУчета"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;
	
КонецФункции // РезультатЗапросаПоНастройкамОтраженияВУчете()

Процедура НайтиДокументыСоответствующиеНастройкам(ТаблицаНастроек, Дата, ТаблицаДокументов) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ИсходнаяТаблица.Организация КАК Организация,
	|	ИсходнаяТаблица.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета
	|
	|ПОМЕСТИТЬ ТаблицаНастроек
	|ИЗ
	|	&ИсходнаяТаблица КАК ИсходнаяТаблица
	|ГДЕ
	|	ИсходнаяТаблица.ДанныеИзменены
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаНастроек.Организация КАК Организация,
	|	Аналитика.КлючАналитики КАК АналитикаУчетаНоменклатуры
	|
	|ПОМЕСТИТЬ ВтАналитика
	|ИЗ
	|	РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ТаблицаНастроек КАК ТаблицаНастроек
	|	ПО
	|		Аналитика.Номенклатура.ГруппаФинансовогоУчета = ТаблицаНастроек.ГруппаФинансовогоУчета
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор КАК Документ,
	|	ОтражениеДокументовВРеглУчете.ДатаОтражения КАК ДатаОтражения,
	|	ОтражениеДокументовВРеглУчете.Организация КАК Организация
	|ИЗ
	|	РегистрНакопления.ТоварыПереданныеНаКомиссию.Обороты(, &ДатаОкончания, Регистратор,
	|		(Организация, АналитикаУчетаНоменклатуры) В (
	|			ВЫБРАТЬ
	|				Аналитика.Организация,
	|				Аналитика.АналитикаУчетаНоменклатуры
	|			ИЗ
	|				ВтАналитика КАК Аналитика
	|		)
	|	) КАК ДанныеРегистра
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтражениеДокументовВРеглУчете КАК ОтражениеДокументовВРеглУчете
	|	ПО
	|		ДанныеРегистра.Регистратор = ОтражениеДокументовВРеглУчете.Регистратор
	|		И ОтражениеДокументовВРеглУчете.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияДокументовВРеглУчете.ОтраженоВРеглУчете)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Документ
	|;");
	ИсходнаяТаблица = ТаблицаНастроек.Выгрузить(, "Организация, ГруппаФинансовогоУчета, ДанныеИзменены");
	Запрос.УстановитьПараметр("ИсходнаяТаблица", ИсходнаяТаблица);
	Запрос.УстановитьПараметр("ДатаОкончания", Дата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ТаблицаДокументов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли