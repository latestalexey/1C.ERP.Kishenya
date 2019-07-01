#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура устанавливает пометку на удаление для найденных элементов справочника.
//
// Параметры:
//	СтруктураПараметров - Структура - Параметры выбора элементов справочника
//	ПометкаУдаления - Булево - Признак установки пометки на удаление
//
Процедура УстановитьПометкуУдаления(СтруктураПараметров, ПометкаУдаления) Экспорт

	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлючиАналитикиУчетаПоПартнерам КАК Таблица
	|ГДЕ
	|	Таблица.ПометкаУдаления <> &ПометкаУдаления
	|");
	Если СтруктураПараметров.Свойство("Партнер") Тогда

		Запрос.УстановитьПараметр("Партнер", СтруктураПараметров.Партнер);
		Запрос.Текст = Запрос.Текст + " И Таблица.Партнер = &Партнер";

	КонецЕсли;
	Если СтруктураПараметров.Свойство("Организация") Тогда

		Запрос.УстановитьПараметр("Организация", СтруктураПараметров.Организация);
		Запрос.Текст = Запрос.Текст + " И Таблица.Организация = &Организация";

	КонецЕсли;
	Если СтруктураПараметров.Свойство("Контрагент") Тогда

		Запрос.УстановитьПараметр("Контрагент", СтруктураПараметров.Контрагент);
		Запрос.Текст = Запрос.Текст + " И Таблица.Контрагент = &Контрагент";

	КонецЕсли;
	Если СтруктураПараметров.Свойство("Договор") Тогда

		Запрос.УстановитьПараметр("Договор", СтруктураПараметров.Договор);
		Запрос.Текст = Запрос.Текст + " И Таблица.Договор = &Договор";

	КонецЕсли;
	Если СтруктураПараметров.Свойство("НаправлениеДеятельности") Тогда

		Запрос.УстановитьПараметр("НаправлениеДеятельности", СтруктураПараметров.НаправлениеДеятельности);
		Запрос.Текст = Запрос.Текст + " И Таблица.НаправлениеДеятельности = &НаправлениеДеятельности";

	КонецЕсли;
	Запрос.УстановитьПараметр("ПометкаУдаления", ПометкаУдаления);

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		Выборка.Ссылка.ПолучитьОбъект().УстановитьПометкуУдаления(ПометкаУдаления);

	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаменаДублейКлючейАналитики

Процедура ЗаменитьДублиКлючейАналитики() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеСправочника.Ссылка КАК Ссылка,
	|	ДанныеСправочника.ПометкаУдаления КАК ПометкаУдаления,
	|	Аналитика.КлючАналитики КАК КлючАналитики
	|ИЗ
	|	Справочник.КлючиАналитикиУчетаПоПартнерам КАК ДанныеСправочника
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаПоПартнерам КАК ДанныеРегистра
	|	ПО
	|		ДанныеСправочника.Ссылка = ДанныеРегистра.КлючАналитики
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаПоПартнерам КАК Аналитика
	|	ПО
	|		ДанныеСправочника.Партнер = Аналитика.Партнер
	|		И ДанныеСправочника.Организация = Аналитика.Организация
	|		И ДанныеСправочника.Контрагент = Аналитика.Контрагент
	|		И ДанныеСправочника.Договор = Аналитика.Договор
	|		И ДанныеСправочника.НаправлениеДеятельности = Аналитика.НаправлениеДеятельности
	|ГДЕ
	|	ДанныеРегистра.КлючАналитики ЕСТЬ NULL
	|");
	
	// Сформируем соответствие ключей аналитики.
	СоответствиеАналитик = Новый Соответствие;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
	
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СоответствиеАналитик.Вставить(Выборка.Ссылка, Выборка.КлючАналитики);
			
			Если Не Выборка.ПометкаУдаления Тогда
				СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
				Попытка
					СправочникОбъект.УстановитьПометкуУдаления(Истина, Ложь);
				Исключение
				КонецПопытки;
			КонецЕсли;

		КонецЦикла;
		
		ОбщегоНазначенияУТ.ЗаменитьСсылки(СоответствиеАналитик);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли