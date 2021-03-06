

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	Возврат; //В дальнейшем будет добавлен код команд

КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.ДоступностьВидаРабочихЦентров) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.ДоступностьВидаРабочихЦентров.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.ДоступностьВидаРабочихЦентров);
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

	Возврат; //В дальнейшем будет добавлен код команд

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаДоступностьВидовРабочихЦентров(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаДоступностьВидовРабочихЦентров(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДоступностьВидовРабочихЦентров";
	
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.ДатаИнтервала КАК Период,
	|	Реквизиты.ВидРабочегоЦентра КАК ВидРабочегоЦентра,
	|	Реквизиты.ВидРабочегоЦентра.Подразделение КАК Подразделение,
	|	Реквизиты.ДатаИнтервала КАК ДатаИнтервала,
	|	Реквизиты.Количество * 3600 КАК ДоступностьПоВидуРЦ,
	|	ВЫБОР Реквизиты.ВидРабочегоЦентра.ЕдиницаИзмеренияДоступностиРЦ
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.ЕдиницыИзмеренияВремени.Минута)
	|			ТОГДА 60
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.ЕдиницыИзмеренияВремени.Час)
	|			ТОГДА 3600
	|		ИНАЧЕ 86400
	|	КОНЕЦ * Реквизиты.ВидРабочегоЦентра.МаксимальнаяДоступностьРЦ КАК МаксимальнаяДоступностьПоВидуРЦ,
	|	ИСТИНА КАК ЭтоДвижениеВводаДоступности,
	|	ЛОЖЬ КАК ЭтоДвижениеЗаказаНаПроизводство,
	|	ЛОЖЬ КАК ЭтоДвижениеМаршрутногоЛиста
	|ИЗ
	|	Документ.ДоступностьВидаРабочихЦентров КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли