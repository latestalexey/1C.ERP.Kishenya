#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт



КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.КассоваяСмена) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.КассоваяСмена.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.КассоваяСмена);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);

	Возврат; //В дальнейшем будет добавлен код команд

КонецПроцедуры


// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

// Функция возвращает статус кассовой смены
//
// Параметры
//  КассоваяСменаСсылка  - Ссылка на смену
//
// Возвращаемое значение:
//   КассоваяСменаСсылка   - Статус кассовой смены
//
Функция СтатусКассовойСмены(КассоваяСменаСсылка) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КассоваяСмена.СтатусКассовойСмены КАК СтатусКассовойСмены
	|ИЗ
	|	Документ.КассоваяСмена КАК КассоваяСмена
	|ГДЕ
	|	КассоваяСмена.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", КассоваяСменаСсылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СтатусКассовойСмены;
	Иначе
		Возврат Перечисления.СтатусыКассовойСмены.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли