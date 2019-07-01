#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает Истина, если объект имеет один из статусов (ПодготовленоПодтверждение, ПодготовленКОтправке Подписан)
//   Параметры:
//     Объект - ДокументСсылка.ПроизвольныйЭД - ссылка на документ
//
//  ВозвращаемоеЗначение:
//    Булево - документ в одном из перечисленных статусов
//
Функция СтатусОбъектаГотов(Объект) Экспорт
	
	Результат = (Объект.СтатусДокумента = Перечисления.СтатусыЭД.ПодготовленоПодтверждение
		ИЛИ Объект.СтатусДокумента = Перечисления.СтатусыЭД.ПодготовленКОтправке
		ИЛИ Объект.СтатусДокумента = Перечисления.СтатусыЭД.Подписан);
		
	Возврат Результат;
	
КонецФункции

// Возвращает Истина, если объект имеет один из статусов (ПереданОператору, Отправлен, ПолученоПодтверждение,
// ОтправленоПодтверждение, ДоставленоПодтверждение)
//   Параметры:
//     Объект - ДокументСсылка.ПроизвольныйЭД - ссылка на документ
//
//  ВозвращаемоеЗначение:
//    Булево - документ в одном из перечисленных статусов
//
Функция СтатусОбъектаПередан(Объект) Экспорт
	
	Результат = (Объект.СтатусДокумента = Перечисления.СтатусыЭД.ПереданОператору
		ИЛИ Объект.СтатусДокумента = Перечисления.СтатусыЭД.Отправлен
		ИЛИ Объект.СтатусДокумента = Перечисления.СтатусыЭД.ПолученоПодтверждение
		ИЛИ Объект.СтатусДокумента = Перечисления.СтатусыЭД.ОтправленоПодтверждение
		ИЛИ Объект.СтатусДокумента = Перечисления.СтатусыЭД.ДоставленоПодтверждение
		ИЛИ (Объект.СтатусДокумента = Перечисления.СтатусыЭД.ПодготовленКОтправке
			И Константы.ИспользоватьОтложеннуюОтправкуЭлектронныхДокументов.Получить()));
		
	Возврат Результат;
	
КонецФункции

// Возвращает Истина, если объект имеет один из статусов (Отклонен, ОтклоненПолучателем
//   Параметры:
//     Объект - ДокументСсылка.ПроизвольныйЭД - ссылка на документ
//
//  ВозвращаемоеЗначение:
//    Булево - документ в одном из перечисленных статусов
//
Функция СтатусОбъектаОтклонен(Объект) Экспорт
	
	Результат = (Объект.СтатусДокумента = Перечисления.СтатусыЭД.Отклонен
		ИЛИ Объект.СтатусДокумента = Перечисления.СтатусыЭД.ОтклоненПолучателем);
		
	Возврат Результат;
	
КонецФункции

// Возвращает Истина, если документ готов к подписанию
//   Параметры:
//     ОбъектЭД - ДокументСсылка.ПроизвольныйЭД - ссылка на документ
//
//  ВозвращаемоеЗначение:
//    Булево - признак готовности подписания
//
Функция МожноПодписывать(ОбъектЭД) Экспорт
	
	НаправлениеИсходящий = (ОбъектЭД.НаправлениеЭД = Перечисления.НаправленияЭД.Исходящий);
	ТребуетсяПодтверждение = ОбъектЭД.ВладелецФайла.ТребуетсяПодтверждение;
	СтатусПередан = СтатусОбъектаПередан(ОбъектЭД.ВладелецФайла);
	СтатусОтклонен = СтатусОбъектаОтклонен(ОбъектЭД.ВладелецФайла);
	
	Результат = (НЕ (СтатусПередан ИЛИ СтатусОтклонен) И (НаправлениеИсходящий ИЛИ ТребуетсяПодтверждение));
	
	Возврат Результат;
	
КонецФункции

// Возвращает Истина, если документ готов к отправке
//   Параметры:
//     ОбъектЭД - ДокументСсылка.ПроизвольныйЭД - ссылка на документ
//
//  ВозвращаемоеЗначение:
//    Булево - признак готовности отправки документа
//
Функция МожноОтправлять(ОбъектЭД) Экспорт
	
	НаправлениеИсходящий = (ОбъектЭД.НаправлениеЭД = Перечисления.НаправленияЭД.Исходящий);
	ТребуетсяПодтверждение = ОбъектЭД.ВладелецФайла.ТребуетсяПодтверждение;
	СтатусГотов = СтатусОбъектаГотов(ОбъектЭД.ВладелецФайла);
	
	Результат = (СтатусГотов И (НаправлениеИсходящий ИЛИ ТребуетсяПодтверждение));
	
	Возврат Результат;
	
КонецФункции

// Обработчик обновления БЭД 1.1.14.2
// Заполняет тип документа
//
Процедура ЗаполнитьТипДокумента() Экспорт
	
	ЭлементСсылка = Документы.ПроизвольныйЭД.Выбрать();
	
	Пока ЭлементСсылка.Следующий() Цикл
		Если НЕ ЗначениеЗаполнено(ЭлементСсылка.ТипДокумента) Тогда
			Попытка
				ЭлементОбъект = ЭлементСсылка.ПолучитьОбъект();
				ЭлементОбъект.ТипДокумента = Перечисления.ТипыЭД.Прочее;
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ЭлементОбъект);
			Исключение
				Операция = НСтр("ru='Запись документа';uk='Запис документа'");
				ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(Операция, ТекстОшибки, ТекстОшибки, 2);
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли