#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Обработчик обновления БЭД 1.1.3.7
// Изменился тип реквизита СтатусЭД в РС ЖурналСобытийЭД со строки на ПеречислениеСсылка.
Процедура ОбновитьСтатусыЭД() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЖурналСобытийЭД.УдалитьСтатусЭД,
	|	ЖурналСобытийЭД.ПрисоединенныйФайл,
	|	ЖурналСобытийЭД.НомерЗаписи
	|ИЗ
	|	РегистрСведений.ЖурналСобытийЭД КАК ЖурналСобытийЭД
	|ГДЕ
	|	ЖурналСобытийЭД.УдалитьСтатусЭД <> """"";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.УдалитьСтатусЭД = "Доставлен получателю" Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.Доставлен;
		ИначеЕсли Выборка.УдалитьСтатусЭД = "<Не получен>" Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.НеПолучен;
		ИначеЕсли Выборка.УдалитьСтатусЭД = "<Не сформирован>" Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.НеСформирован;
		ИначеЕсли Выборка.УдалитьСтатусЭД = "Отправлен получателю" Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.Отправлен;
		ИначеЕсли Выборка.УдалитьСтатусЭД = "Отправлено уведомление об уточнении" Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.ОтправленоУведомление;
		ИначеЕсли Выборка.УдалитьСтатусЭД = "Отправлен оператору ЭДО" Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.ПереданОператору;
		ИначеЕсли Выборка.УдалитьСтатусЭД = "Получено уведомление об уточнении" Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.ПолученоУведомление;
		Иначе
			УдалитьСтатусЭД = СтрЗаменить(Выборка.УдалитьСтатусЭД, " ", "");
			УдалитьСтатусЭД = Перечисления.СтатусыЭД[УдалитьСтатусЭД];
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.ЖурналСобытийЭД.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ПрисоединенныйФайл.Установить(Выборка.ПрисоединенныйФайл);
		НаборЗаписей.Отбор.НомерЗаписи.Установить(Выборка.НомерЗаписи);
		НаборЗаписей.Прочитать();
		Для Каждого Запись Из НаборЗаписей Цикл
			Запись.СтатусЭД = УдалитьСтатусЭД;
		КонецЦикла;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли