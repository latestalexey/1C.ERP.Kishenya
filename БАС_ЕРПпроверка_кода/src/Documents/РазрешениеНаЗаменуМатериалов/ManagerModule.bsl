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

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.РазрешениеНаЗаменуМатериалов) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.РазрешениеНаЗаменуМатериалов.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.РазрешениеНаЗаменуМатериалов);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьПроизводство";
	

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

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);

КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
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
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаАналогиВПроизводстве(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	РазрешениеНаЗаменуМатериалов.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	РазрешениеНаЗаменуМатериалов.Спецификация КАК Спецификация,
	|	РазрешениеНаЗаменуМатериалов.Изделие КАК Изделие,
	|	РазрешениеНаЗаменуМатериалов.ХарактеристикаИзделия КАК ХарактеристикаИзделия,
	|	РазрешениеНаЗаменуМатериалов.ЗаказКлиента КАК ЗаказКлиента,
	|	РазрешениеНаЗаменуМатериалов.ДатаНачалаДействия КАК ДатаНачалаДействия,
	|	РазрешениеНаЗаменуМатериалов.ДатаОкончанияДействия КАК ДатаОкончанияДействия,
	|	РазрешениеНаЗаменуМатериалов.Статус КАК Статус,
	|	РазрешениеНаЗаменуМатериалов.Подразделение КАК Подразделение
	|ИЗ
	|	Документ.РазрешениеНаЗаменуМатериалов КАК РазрешениеНаЗаменуМатериалов
	|ГДЕ
	|	РазрешениеНаЗаменуМатериалов.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Статус",                    Реквизиты.Статус);
	Запрос.УстановитьПараметр("ЗаказНаПроизводство",       Реквизиты.ЗаказНаПроизводство);
	Запрос.УстановитьПараметр("Спецификация",              Реквизиты.Спецификация);
	Запрос.УстановитьПараметр("Изделие",                   Реквизиты.Изделие);
	Запрос.УстановитьПараметр("ХарактеристикаИзделия",     Реквизиты.ХарактеристикаИзделия);
	Запрос.УстановитьПараметр("ЗаказКлиента",              Реквизиты.ЗаказКлиента);
	Запрос.УстановитьПараметр("ДатаНачалаДействия",        Реквизиты.ДатаНачалаДействия);
	Запрос.УстановитьПараметр("ДатаОкончанияДействия",     Реквизиты.ДатаОкончанияДействия);
	Запрос.УстановитьПараметр("Подразделение",             Реквизиты.Подразделение);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаАналогиВПроизводстве(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "АналогиВПроизводстве";
	
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	&Спецификация КАК Спецификация,
	|	&Изделие КАК Изделие,
	|	&ХарактеристикаИзделия КАК ХарактеристикаИзделия,
	|	&ЗаказКлиента КАК ЗаказКлиента,
	|	&ДатаНачалаДействия КАК Период,
	|	&ДатаОкончанияДействия КАК ПериодЗавершения,
	|	&Подразделение КАК Подразделение,
	|	РазрешениеНаЗаменуМатериаловМатериалы.Номенклатура КАК Материал,
	|	РазрешениеНаЗаменуМатериаловМатериалы.Характеристика КАК ХарактеристикаМатериала,
	|	РазрешениеНаЗаменуМатериаловМатериалы.Количество КАК КоличествоМатериала,
	|	РазрешениеНаЗаменуМатериаловМатериалы.КоличествоУпаковок КАК КоличествоУпаковокМатериала,
	|	РазрешениеНаЗаменуМатериаловМатериалы.Упаковка КАК УпаковкаМатериала,
	|	РазрешениеНаЗаменуМатериаловМатериалы.КлючСвязиСпецификация КАК КлючСвязиСпецификация,
	|	РазрешениеНаЗаменуМатериаловАналоги.Номенклатура КАК Аналог,
	|	РазрешениеНаЗаменуМатериаловАналоги.Характеристика КАК ХарактеристикаАналога,
	|	РазрешениеНаЗаменуМатериаловАналоги.Количество КАК КоличествоАналога,
	|	РазрешениеНаЗаменуМатериаловАналоги.КоличествоУпаковок КАК КоличествоУпаковокАналога,
	|	РазрешениеНаЗаменуМатериаловАналоги.Упаковка КАК УпаковкаАналога
	|ИЗ
	|	Документ.РазрешениеНаЗаменуМатериалов.Материалы КАК РазрешениеНаЗаменуМатериаловМатериалы,
	|	Документ.РазрешениеНаЗаменуМатериалов.Аналоги КАК РазрешениеНаЗаменуМатериаловАналоги
	|ГДЕ
	|	РазрешениеНаЗаменуМатериаловАналоги.Ссылка = &Ссылка
	|	И РазрешениеНаЗаменуМатериаловМатериалы.Ссылка = &Ссылка
	|	И &Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыРазрешенийНаЗаменуМатериалов.Утверждено)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли