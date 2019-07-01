#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Перем ОбновитьНоменклатуруГТД;

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	Если Не ПометкаУдаления Тогда
		ПроверитьДублиЭлемента(Отказ);
	КонецЕсли;
	
	// Наименование номенклатуры ГТД формируется автоматически и использует номер ГТД и ее дату
	ОбновитьНоменклатуруГТД = (Не ЭтоНовый()) И ((Ссылка.Код <> Код) ИЛИ (Ссылка.Дата <> Дата));
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

  	// необходимо перезаписать (перезаполнить наименования и реквизиты) в справочнике НоменклатураГТД, если изменился код справочника
	Если ОбновитьНоменклатуруГТД Тогда
		ОбновитьНоменклатуруГТД();
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Процедура ПроверитьДублиЭлемента(Отказ)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	НомераГТД.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НомераГТД КАК НомераГТД
	|ГДЕ
	|	НомераГТД.Ссылка <> &Ссылка
	|	И Не НомераГТД.ПометкаУдаления
	|	И НомераГТД.Код = &Код
	|");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Код", Код);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Аналогичный номер ГТД уже существует: %1';uk='Аналогічний номер ВМД вже існує: %1'"),
			Выборка.Ссылка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			, // Поле
			,
			Отказ);
		
	КонецЕсли;
	
КонецПроцедуры


Процедура ОбновитьНоменклатуруГТД()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НоменклатураГТД.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НоменклатураГТД КАК НоменклатураГТД
	|ГДЕ
	|	НоменклатураГТД.НомерГТД = &Ссылка";
				   
	Попытка
		Справочники.НоменклатураГТД.ПоискИИсправлениеНекорректныхНаименований(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	Исключение
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось обновить данные справочника ""%1"". Отображение номера ГТД в наименовании этого справочника может быть не правильным!';uk='Не вдалося оновити дані довідника ""%1"". Відображення номера ВМД у найменуванні цього довідника може бути не правильним!'"), Метаданные.Справочники.НоменклатураГТД.Синоним);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка, "", , );
	КонецПопытки;
	
КонецПроцедуры

ОбновитьНоменклатуруГТД = Ложь;
 
#КонецОбласти

#КонецОбласти

#КонецЕсли
