#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый", ДополнительныеСвойства.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Организация КАК Организация,
	|	Таблица.Подразделение КАК Подразделение,
	|	Таблица.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Таблица.Партия КАК Партия,
	|	Таблица.Количество КАК КоличествоПередЗаписью
	|ПОМЕСТИТЬ ДвиженияТМЦВЭксплуатацииПередЗаписью
	|ИЗ
	|	РегистрНакопления.ТМЦВЭксплуатации КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И НЕ &ЭтоНовый";
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаИзменений.Организация КАК Организация,
	|	ТаблицаИзменений.Подразделение КАК Подразделение,
	|	ТаблицаИзменений.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ТаблицаИзменений.Партия КАК Партия,
	|	СУММА(ТаблицаИзменений.КоличествоИзменение) КАК КоличествоИзменение
	|ПОМЕСТИТЬ ДвиженияТМЦВЭксплуатацииИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Организация КАК Организация,
	|		Таблица.Подразделение КАК Подразделение,
	|		Таблица.ФизическоеЛицо КАК ФизическоеЛицо,
	|		Таблица.Партия КАК Партия,
	|		Таблица.КоличествоПередЗаписью КАК КоличествоИзменение
	|	ИЗ
	|		ДвиженияТМЦВЭксплуатацииПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.Организация КАК Организация,
	|		Таблица.Подразделение КАК Подразделение,
	|		Таблица.ФизическоеЛицо КАК ФизическоеЛицо,
	|		Таблица.Партия КАК Партия,
	|		-Таблица.Количество КАК КоличествоИзменение
	|	ИЗ
	|		РегистрНакопления.ТМЦВЭксплуатации КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Организация,
	|	ТаблицаИзменений.Подразделение,
	|	ТаблицаИзменений.ФизическоеЛицо,
	|	ТаблицаИзменений.Партия
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.КоличествоИзменение) > 0
	|;
	|УНИЧТОЖИТЬ ДвиженияТМЦВЭксплуатацииПередЗаписью
	|";
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	Выборка.Следующий();
	
	// Новые изменения были помещены во временную таблицу.
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	
	СтруктураВременныеТаблицы.Вставить("ДвиженияТМЦВЭксплуатацииИзменение", Выборка.Количество > 0);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли