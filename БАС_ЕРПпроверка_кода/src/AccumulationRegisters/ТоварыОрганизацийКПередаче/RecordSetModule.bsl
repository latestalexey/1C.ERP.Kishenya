#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Товары.Период                     КАК Период,
	|	Товары.Регистратор                КАК Регистратор,
	|	Товары.ОрганизацияВладелец        КАК ОрганизацияВладелец,
	|	Товары.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Товары.ВидЗапасовПродавца         КАК ВидЗапасовПродавца,
	|	Товары.НомерГТД                   КАК НомерГТД,
	|
	|	Товары.Количество КАК Количество,
	|	Товары.Возвращено КАК Возвращено,
	|
	|	Товары.НалоговоеНазначение   КАК НалоговоеНазначение,
	|	Товары.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Товары.Номенклатура          КАК Номенклатура,
	|	Товары.Характеристика        КАК Характеристика,
	|	Товары.КорВидЗапасов         КАК КорВидЗапасов,
	|	Товары.Первичное             КАК Первичное
	|ПОМЕСТИТЬ ТоварыКПередачеПередЗаписью
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизацийКПередаче КАК Товары
	|ГДЕ
	|	Товары.Регистратор = &Регистратор
	|	И &ИспользоватьПартионныйУчет
	|");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ИспользоватьПартионныйУчет", ДополнительныеСвойства.ДляПроведения.ПартионныйУчет);
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК МЕСЯЦ,
	|	Таблица.ОрганизацияВладелец          КАК Организация,
	|	Таблица.Регистратор                  КАК Документ
	|ИЗ
	|	(ВЫБРАТЬ
	|		Товары.Период                     КАК Период,
	|		Товары.Регистратор                КАК Регистратор,
	|		Товары.ОрганизацияВладелец        КАК ОрганизацияВладелец,
	|		Товары.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		Товары.ВидЗапасовПродавца         КАК ВидЗапасовПродавца,
	|		Товары.НомерГТД                   КАК НомерГТД,
	|
	|		Товары.Количество КАК Количество,
	|		Товары.Возвращено КАК Возвращено,
	|
	|		Товары.НалоговоеНазначение   КАК НалоговоеНазначение,
	|		Товары.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|		Товары.Номенклатура          КАК Номенклатура,
	|		Товары.Характеристика        КАК Характеристика,
	|		Товары.КорВидЗапасов         КАК КорВидЗапасов,
	|		Товары.Первичное             КАК Первичное
	|	ИЗ
	|		ТоварыКПередачеПередЗаписью КАК Товары
	|	ГДЕ
	|		&ИспользоватьПартионныйУчет
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Товары.Период                     КАК Период,
	|		Товары.Регистратор                КАК Регистратор,
	|		Товары.ОрганизацияВладелец        КАК ОрганизацияВладелец,
	|		Товары.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		Товары.ВидЗапасовПродавца         КАК ВидЗапасовПродавца,
	|		Товары.НомерГТД                   КАК НомерГТД,
	|
	|		-Товары.Количество КАК Количество,
	|		-Товары.Возвращено КАК Возвращено,
	|
	|		Товары.НалоговоеНазначение   КАК НалоговоеНазначение,
	|		Товары.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|		Товары.Номенклатура          КАК Номенклатура,
	|		Товары.Характеристика        КАК Характеристика,
	|		Товары.КорВидЗапасов         КАК КорВидЗапасов,
	|		Товары.Первичное             КАК Первичное
	|	ИЗ
	|		РегистрНакопления.ТоварыОрганизацийКПередаче КАК Товары
	|	ГДЕ
	|		Товары.Регистратор = &Регистратор
	|		И &ИспользоватьПартионныйУчет
	|	) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ),
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.ОрганизацияВладелец,
	|	Таблица.АналитикаУчетаНоменклатуры,
	|	Таблица.ВидЗапасовПродавца,
	|	Таблица.НомерГТД,
	|	Таблица.НалоговоеНазначение,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.КорВидЗапасов,
	|	Таблица.Первичное
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Количество) <> 0
	|	ИЛИ СУММА(Таблица.Возвращено) <> 0
	|");
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ИспользоватьПартионныйУчет", ДополнительныеСвойства.ДляПроведения.ПартионныйУчет);
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьЗаписиРегистраПоДаннымВыборки(Запрос.Выполнить().Выбрать());
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли