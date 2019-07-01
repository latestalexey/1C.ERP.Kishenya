#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	Если Не ПроведениеСервер.ЗаписыватьПодчиненныеДанные(ДополнительныеСвойства, "СостоянияЗаказов") Тогда
		ПроведениеСервер.ДобавитьСтруктуруЗаписиПодчиненныхДанных(ДополнительныеСвойства, "СостоянияЗаказов");
	КонецЕсли;
	
	ДополнитьМассивЗаказовДляРасчетаСостояний(ДополнительныеСвойства);
	
	Если Не ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;

	// Текущее состояние набора помещается во временную таблицу
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.ДокументОтгрузки КАК ДокументОтгрузки,
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.Назначение КАК Назначение,
	|	Таблица.Серия КАК Серия,
	|	Таблица.Склад КАК Склад,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.ВРезерве + Таблица.КОтгрузке
	|		ИНАЧЕ -Таблица.ВРезерве - Таблица.КОтгрузке
	|	КОНЕЦ КАК ВРезервеКОтгрузкеПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.КОтгрузке
	|		ИНАЧЕ -Таблица.КОтгрузке
	|	КОНЕЦ КАК КОтгрузкеПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА -Таблица.Собирается
	|		ИНАЧЕ Таблица.Собирается
	|	КОНЕЦ КАК СобираетсяПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА -Таблица.Собрано
	|		ИНАЧЕ Таблица.Собрано
	|	КОНЕЦ КАК СобраноПередЗаписью
	|ПОМЕСТИТЬ ДвиженияТоварыКОтгрузкеПередЗаписью
	|ИЗ
	|	РегистрНакопления.ТоварыКОтгрузке КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.ДокументОтгрузки КАК ДокументОтгрузки,
	|	Таблица.Получатель КАК Получатель,
	|	Таблица.Период КАК Период,
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.Назначение КАК Назначение,
	|	Таблица.Серия КАК Серия,
	|	Таблица.Склад КАК Склад,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.КОтгрузке
	|		ИНАЧЕ -Таблица.КОтгрузке
	|	КОНЕЦ КАК КОтгрузкеПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА -Таблица.Собирается
	|		ИНАЧЕ Таблица.Собирается
	|	КОНЕЦ КАК СобираетсяПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА -Таблица.Собрано
	|		ИНАЧЕ Таблица.Собрано
	|	КОНЕЦ КАК СобраноПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА -Таблица.КОформлению
	|		ИНАЧЕ Таблица.КОформлению
	|	КОНЕЦ КАК КОформлениюПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА -Таблица.КСборке
	|		ИНАЧЕ Таблица.КСборке
	|	КОНЕЦ КАК КСборкеПередЗаписью
	|ПОМЕСТИТЬ ДвиженияТоварыКОтгрузкеПоПериодуПередЗаписью
	|ИЗ
	|	РегистрНакопления.ТоварыКОтгрузке КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор";
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)

	РежимыФормированияРасходныхОрдеровАвтоматически = Константы.РежимФормированияРасходныхОрдеров.Получить() = Перечисления.РежимыФормированияРасходныхОрдеров.Автоматически;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если Не ПроведениеСервер.ЗаписыватьПодчиненныеДанные(ДополнительныеСвойства, "СостоянияЗаказов") Тогда
		ПроведениеСервер.ДобавитьСтруктуруЗаписиПодчиненныхДанных(ДополнительныеСвойства, "СостоянияЗаказов");
	КонецЕсли;
	ДополнитьМассивЗаказовДляРасчетаСостояний(ДополнительныеСвойства);
	
	Если ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		
		СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
		
		// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
		// и помещается во временную таблицу.
		Запрос = Новый Запрос;
		ОформлятьСначалаНакладные = Константы.ПорядокОформленияНакладныхРасходныхОрдеров.Получить() = Перечисления.ПорядокОформленияНакладныхРасходныхОрдеров.СначалаНакладные;
		Запрос.УстановитьПараметр("ОформлятьСначалаНакладные", ОформлятьСначалаНакладные);
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаИзменений.ДокументОтгрузки КАК ДокументОтгрузки,
		|	ТаблицаИзменений.Номенклатура КАК Номенклатура,
		|	ТаблицаИзменений.Характеристика КАК Характеристика,
		|	ТаблицаИзменений.Назначение КАК Назначение,
		|	ТаблицаИзменений.Серия КАК Серия,
		|	ТаблицаИзменений.Склад КАК Склад,
		|	СУММА(ТаблицаИзменений.КОтгрузкеИзменение) КАК КОтгрузкеИзменение,
		|	СУММА(ТаблицаИзменений.СобираетсяИзменение) КАК СобираетсяИзменение,
		|	СУММА(ТаблицаИзменений.СобираетсяИзменение) КАК СобраноИзменение
		|ПОМЕСТИТЬ ДвиженияТоварыКОтгрузкеИзменение
		|ИЗ
		|	(ВЫБРАТЬ
		|		Таблица.ДокументОтгрузки КАК ДокументОтгрузки,
		|		Таблица.Номенклатура КАК Номенклатура,
		|		Таблица.Характеристика КАК Характеристика,
		|		Таблица.Назначение КАК Назначение,
		|		Таблица.Серия КАК Серия,
		|		Таблица.Склад КАК Склад,
		|		Таблица.КОтгрузкеПередЗаписью КАК КОтгрузкеИзменение,
		|		Таблица.СобираетсяПередЗаписью КАК СобираетсяИзменение,
		|		Таблица.СобраноПередЗаписью КАК СобраноИзменение
		|	ИЗ
		|		ДвиженияТоварыКОтгрузкеПередЗаписью КАК Таблица
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		Таблица.ДокументОтгрузки,
		|		Таблица.Номенклатура,
		|		Таблица.Характеристика,
		|		Таблица.Назначение,
		|		Таблица.Серия,
		|		Таблица.Склад,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА -Таблица.КОтгрузке
		|			ИНАЧЕ Таблица.КОтгрузке
		|		КОНЕЦ,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.Собирается
		|			ИНАЧЕ -Таблица.Собирается
		|		КОНЕЦ,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.Собрано
		|			ИНАЧЕ -Таблица.Собрано
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.ТоварыКОтгрузке КАК Таблица
		|	ГДЕ
		|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаИзменений.ДокументОтгрузки,
		|	ТаблицаИзменений.Номенклатура,
		|	ТаблицаИзменений.Характеристика,
		|	ТаблицаИзменений.Назначение,
		|	ТаблицаИзменений.Серия,
		|	ТаблицаИзменений.Склад
		|
		|ИМЕЮЩИЕ
		|	(СУММА(ТаблицаИзменений.КОтгрузкеИзменение) > 0
		|		ИЛИ СУММА(ТаблицаИзменений.СобираетсяИзменение) > 0
		|		ИЛИ СУММА(ТаблицаИзменений.СобраноИзменение) > 0)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Т.Номенклатура КАК Номенклатура,
		|	Т.Характеристика КАК Характеристика,
		|	Т.Назначение КАК Назначение,
		|	Т.Серия КАК Серия,
		|	Т.Склад КАК Склад,
		|	СУММА(Т.УвеличениеПрихода) КАК УвеличениеПрихода
		|ПОМЕСТИТЬ ДвиженияТоварыКОтгрузкеИзменениеСводно
		|ИЗ
		|	(ВЫБРАТЬ
		|		Таблица.Номенклатура КАК Номенклатура,
		|		Таблица.Характеристика КАК Характеристика,
		|		Таблица.Назначение КАК Назначение,
		|		Таблица.Серия КАК Серия,
		|		Таблица.Склад КАК Склад,
		|		-Таблица.ВРезервеКОтгрузкеПередЗаписью КАК УвеличениеПрихода
		|	ИЗ
		|		ДвиженияТоварыКОтгрузкеПередЗаписью КАК Таблица
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		Таблица.Номенклатура,
		|		Таблица.Характеристика,
		|		Таблица.Назначение,
		|		Таблица.Серия,
		|		Таблица.Склад,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.ВРезерве + Таблица.КОтгрузке
		|			ИНАЧЕ -Таблица.ВРезерве - Таблица.КОтгрузке
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.ТоварыКОтгрузке КАК Таблица
		|	ГДЕ
		|		Таблица.Регистратор = &Регистратор) КАК Т
		|ГДЕ
		|	Т.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	Т.Номенклатура,
		|	Т.Склад,
		|	Т.Характеристика,
		|	Т.Назначение,
		|	Т.Серия
		|
		|ИМЕЮЩИЕ
		|	СУММА(Т.УвеличениеПрихода) > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаИзменений.Склад КАК Склад,
		|	ТаблицаИзменений.Получатель КАК Получатель,
		|	МИНИМУМ(ТаблицаИзменений.Период) КАК Период
		|ИЗ
		|	(ВЫБРАТЬ
		|		Таблица.Период КАК Период,
		|		Таблица.Получатель КАК Получатель,
		|		Таблица.ДокументОтгрузки КАК ДокументОтгрузки,
		|		Таблица.Номенклатура КАК Номенклатура,
		|		Таблица.Характеристика КАК Характеристика,
		|		Таблица.Назначение КАК Назначение,
		|		Таблица.Серия КАК Серия,
		|		Таблица.Склад КАК Склад,
		|		Таблица.КОтгрузкеПередЗаписью КАК КОтгрузкеИзменение,
		|		Таблица.КОформлениюПередЗаписью КАК КОформлениюИзменение,
		|		Таблица.КСборкеПередЗаписью КАК КСборкеИзменение,
		|		Таблица.СобираетсяПередЗаписью КАК СобираетсяИзменение,
		|		Таблица.СобраноПередЗаписью КАК СобраноИзменение
		|	ИЗ
		|		ДвиженияТоварыКОтгрузкеПоПериодуПередЗаписью КАК Таблица
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		Таблица.Период,
		|		Таблица.Получатель,
		|		Таблица.ДокументОтгрузки,
		|		Таблица.Номенклатура,
		|		Таблица.Характеристика,
		|		Таблица.Назначение,
		|		Таблица.Серия,
		|		Таблица.Склад,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА -Таблица.КОтгрузке
		|			ИНАЧЕ Таблица.КОтгрузке
		|		КОНЕЦ,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.КОформлению
		|			ИНАЧЕ -Таблица.КОформлению
		|		КОНЕЦ,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.КСборке
		|			ИНАЧЕ -Таблица.КСборке
		|		КОНЕЦ,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.Собирается
		|			ИНАЧЕ -Таблица.Собирается
		|		КОНЕЦ,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.Собрано
		|			ИНАЧЕ -Таблица.Собрано
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.ТоварыКОтгрузке КАК Таблица
		|	ГДЕ
		|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаИзменений.Склад,
		|	ТаблицаИзменений.Получатель
		|
		|ИМЕЮЩИЕ
		|	(СУММА(ТаблицаИзменений.КОтгрузкеИзменение) + СУММА(ТаблицаИзменений.КСборкеИзменение) + СУММА(ТаблицаИзменений.СобираетсяИзменение) + СУММА(ТаблицаИзменений.СобраноИзменение) <> 0
		|		ИЛИ СУММА(ТаблицаИзменений.КОформлениюИзменение) <> 0
		|			И &ОформлятьСначалаНакладные)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Склад,
		|	Получатель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ДвиженияТоварыКОтгрузкеПередЗаписью
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ДвиженияТоварыКОтгрузкеПоПериодуПередЗаписью";
		
		ЗапросПакет = Запрос.ВыполнитьПакет();
		Выборка = ЗапросПакет[0].Выбрать();
		Выборка.Следующий();
		// Новые изменения были помещены во временную таблицу.
		// Добавляется информация о ее существовании и наличии в ней записей об изменении.
		СтруктураВременныеТаблицы.Вставить("ДвиженияТоварыКОтгрузкеИзменение", Выборка.Количество > 0);
		
		Выборка = ЗапросПакет[1].Выбрать();
		Выборка.Следующий();
		СтруктураВременныеТаблицы.Вставить("ДвиженияТоварыКОтгрузкеИзменениеСводно", Выборка.Количество > 0);
	
		ВыборкаСкладПолучатель = ЗапросПакет[2].Выбрать();
		
	// Если изменения не расчитываются(документ новый),
	// то для переоформления расходных ордеров достаточно чтобы движения хотя бы по одному ресурсу не были равны 0
	ИначеЕсли РежимыФормированияРасходныхОрдеровАвтоматически Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаИзменений.Склад КАК Склад,
		|	ТаблицаИзменений.Получатель КАК Получатель,
		|	МИНИМУМ(ТаблицаИзменений.Период) КАК Период
		|ИЗ
		|	(ВЫБРАТЬ
		|		Таблица.Период,
		|		Таблица.Получатель,
		|		Таблица.ДокументОтгрузки,
		|		Таблица.Номенклатура,
		|		Таблица.Характеристика,
		|		Таблица.Назначение,
		|		Таблица.Серия,
		|		Таблица.Склад,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА -Таблица.КОтгрузке
		|			ИНАЧЕ Таблица.КОтгрузке
		|		КОНЕЦ КАК КОтгрузкеИзменение,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.КОформлению
		|			ИНАЧЕ -Таблица.КОформлению
		|		КОНЕЦ КАК КОформлениюИзменение,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.КСборке
		|			ИНАЧЕ -Таблица.КСборке
		|		КОНЕЦ КАК КСборкеИзменение,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.Собирается
		|			ИНАЧЕ -Таблица.Собирается
		|		КОНЕЦ КАК СобираетсяИзменение,
		|		ВЫБОР
		|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|				ТОГДА Таблица.Собрано
		|			ИНАЧЕ -Таблица.Собрано
		|		КОНЕЦ КАК СобраноИзменение
		|	ИЗ
		|		РегистрНакопления.ТоварыКОтгрузке КАК Таблица
		|	ГДЕ
		|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаИзменений.Склад,
		|	ТаблицаИзменений.Получатель
		|
		|ИМЕЮЩИЕ
		|	(СУММА(ТаблицаИзменений.КОтгрузкеИзменение) + СУММА(ТаблицаИзменений.КСборкеИзменение) + СУММА(ТаблицаИзменений.СобираетсяИзменение) + СУММА(ТаблицаИзменений.СобраноИзменение) <> 0
		|		ИЛИ СУММА(ТаблицаИзменений.КОформлениюИзменение) <> 0
		|			И &ОформлятьСначалаНакладные)";
		ОформлятьСначалаНакладные = Константы.ПорядокОформленияНакладныхРасходныхОрдеров.Получить() = Перечисления.ПорядокОформленияНакладныхРасходныхОрдеров.СначалаНакладные;
		Запрос.УстановитьПараметр("ОформлятьСначалаНакладные", ОформлятьСначалаНакладные);
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		ВыборкаСкладПолучатель = Запрос.Выполнить().Выбрать();
		
	КонецЕсли;
	
	Если РежимыФормированияРасходныхОрдеровАвтоматически Тогда
		
		Пока ВыборкаСкладПолучатель.Следующий() Цикл
			
			Склад = ВыборкаСкладПолучатель.Склад;
			Получатель = ВыборкаСкладПолучатель.Получатель;
			
			Если Не СкладыСервер.ИспользоватьОрдернуюСхемуПриОтгрузке(Склад, ВыборкаСкладПолучатель.Период) Тогда
				Возврат;
			КонецЕсли;
			
			Если СкладыСервер.ТребуетсяПереоформитьРасходныеОрдера(Склад, Получатель) Тогда
				
				СкладыСервер.ДобавитьВОчередьФормированияРасходныхОрдеров(Склад, Получатель, Отбор.Регистратор.Значение);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьМассивЗаказовДляРасчетаСостояний(ДополнительныеСвойства)
	
	СтруктураДляРасчетаСостояний = ДополнительныеСвойства.ДляЗаписиПодчиненныхДанных.СтруктураДляРасчетаСостояний;
	
	// Заказы из текущего состояния набора добавляем к общему массиву заказов.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("МассивЗаказов", СтруктураДляРасчетаСостояний.МассивЗаказов);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Таблица.ДокументОтгрузки КАК Заказ
		|ИЗ
		|	РегистрНакопления.ТоварыКОтгрузке КАК Таблица
		|ГДЕ
		|	Таблица.Регистратор = &Регистратор
		|	И НЕ Таблица.ДокументОтгрузки В (&МассивЗаказов)";
	МассивЗаказов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Заказ");
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СтруктураДляРасчетаСостояний.МассивЗаказов, МассивЗаказов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли