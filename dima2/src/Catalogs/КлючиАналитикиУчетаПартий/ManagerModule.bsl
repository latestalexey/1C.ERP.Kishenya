#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция получает ключ аналитики учета партий для текущего документа.
//
// Параметры:
//	РеквизитыДокумента - Структура или ВыборкаИзРезультатаЗапроса - Данные документа
//
// Возвращаемое значение:
//	СправочникСсылка.КлючиАналитикиУчетаПартий - Найденный ключ аналитики учета партий
//
Функция КлючиАналитикиУчетаПартийДокумента(РеквизитыДокумента = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураКлючейАналитикПартий = СтруктураАналитикУчетаПартий(РеквизитыДокумента);
	
	МенеджерЗаписи = РегистрыСведений.АналитикаУчетаПартий.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтруктураКлючейАналитикПартий);
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда
		Результат = МенеджерЗаписи.КлючАналитики;
	Иначе
		Результат = СоздатьКлючАналитики(СтруктураКлючейАналитикПартий);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Функция формирует строку наименования ключа аналитики учета партий.
//
// Параметры:
//	СправочникОбъект - Ключ аналитики учета партий, для которой необходимо определить наименовние
//
// Возвращаемое значение:
//	Строка - Наименование ключа аналитики учета номенклатуры
//
Функция ПолучитьНаименованиеКлючаАналитикиУчетаПартий(СправочникОбъект) Экспорт
	
	Наименование = "";
		
	Если ЗначениеЗаполнено(СправочникОбъект.ГруппаФинансовогоУчета) Тогда
		Наименование = Наименование
			+ "Группа: " + СправочникОбъект.ГруппаФинансовогоУчета+"; ";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СправочникОбъект.Поставщик) Тогда
		Наименование = Наименование
			+ "Поставщик: " + СправочникОбъект.Поставщик+"; ";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СправочникОбъект.Контрагент) Тогда
		Наименование = Наименование
			+ "Контрагент: " + СправочникОбъект.Контрагент+"; ";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СправочникОбъект.НалоговоеНазначение) Тогда
		Наименование = Наименование
			+ "Налоговое назначение: " + СправочникОбъект.НалоговоеНазначение+"; ";
	КонецЕсли;
		
	Если ЗначениеЗаполнено(СправочникОбъект.СтавкаНДС) Тогда
		Наименование = Наименование
			+ "Ставка НДС: " + СправочникОбъект.СтавкаНДС;
	КонецЕсли;  	
   		
	Если Прав(СокрЛП(СправочникОбъект.Наименование), 1) =  ";" Тогда
		Наименование = Сред(СокрЛП(Наименование), 1, СтрДлина(СокрЛП(Наименование)) - 1);
	КонецЕсли;
			
	Возврат Наименование;

КонецФункции

// Процедура устанавливает пометку на удаление для найденных элементов справочника.
//
// Параметры:
//	СтруктураПараметров - Структура - Параметры выбора элементов справочника
//	ПометкаУдаления - Булево - Признак установки пометки на удаление
//
Процедура УстановитьПометкуУдаления(СтруктураПараметров, ПометкаУдаления) Экспорт

	УстановитьПривилегированныйРежим(Истина);

	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлючиАналитикиУчетаПартий КАК Таблица
	|ГДЕ
	|	Таблица.ПометкаУдаления <> &ПометкаУдаления
	|";
	Запрос = Новый Запрос;
	Если СтруктураПараметров.Свойство("ГруппаФинансовогоУчета") Тогда
		Запрос.УстановитьПараметр("ГруппаФинансовогоУчета", СтруктураПараметров.ГруппаФинансовогоУчета);
		ТекстЗапроса = ТекстЗапроса + " И Таблица.ГруппаФинансовогоУчета = &ГруппаФинансовогоУчета";
	КонецЕсли;
	Если СтруктураПараметров.Свойство("Партнер") Тогда
		Запрос.УстановитьПараметр("Поставщик", СтруктураПараметров.Партнер);
		ТекстЗапроса = ТекстЗапроса + " И Таблица.Поставщик = &Поставщик";
	КонецЕсли;
	Если СтруктураПараметров.Свойство("Контрагент") Тогда
		Запрос.УстановитьПараметр("Контрагент", СтруктураПараметров.Контрагент);
		ТекстЗапроса = ТекстЗапроса + " И Таблица.Контрагент = &Контрагент";
	КонецЕсли;
	Если СтруктураПараметров.Свойство("НалоговоеНазначение") Тогда
		Запрос.УстановитьПараметр("НалоговоеНазначение", СтруктураПараметров.НалоговоеНазначение);
		ТекстЗапроса = ТекстЗапроса + " И Таблица.НалоговоеНазначение = &НалоговоеНазначение";
	КонецЕсли;
	Если СтруктураПараметров.Свойство("СтавкаНДС") Тогда
		Запрос.УстановитьПараметр("СтавкаНДС", СтруктураПараметров.СтавкаНДС);
		ТекстЗапроса = ТекстЗапроса + " И Таблица.СтавкаНДС = &СтавкаНДС";
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ПометкаУдаления", ПометкаУдаления);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Выборка.Ссылка.ПолучитьОбъект().УстановитьПометкуУдаления(ПометкаУдаления);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция СтруктураАналитикУчетаПартий(РеквизитыДокумента)
	
	СтруктураАналитикУчетаПартий = Новый Структура("
		|ГруппаФинансовогоУчета,
		|Поставщик,
		|Контрагент,
		|НалоговоеНазначение,
		|СтавкаНДС,
		|");
	СтруктураАналитикУчетаПартий.ГруппаФинансовогоУчета 	= РеквизитыДокумента.ГруппаФинансовогоУчета;
	СтруктураАналитикУчетаПартий.Поставщик 				 	= РеквизитыДокумента.Поставщик;
	СтруктураАналитикУчетаПартий.Контрагент 				= РеквизитыДокумента.Контрагент;
	СтруктураАналитикУчетаПартий.НалоговоеНазначение  		= РеквизитыДокумента.НалоговоеНазначение;
	СтруктураАналитикУчетаПартий.СтавкаНДС 		 		 	= РеквизитыДокумента.СтавкаНДС;
		
	Возврат СтруктураАналитикУчетаПартий;
	
КонецФункции

Функция НайтиАналитикуУчетаПартий (СтруктураАналитикУчетаПартий)

	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Ключ.НалоговоеНазначение   	КАК НалоговоеНазначение,
	|	Ключ.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	Ключ.Поставщик 				КАК Поставщик,
	|	Ключ.Контрагент				КАК Контрагент,
	|	Ключ.Наименование 			КАК Наименование,
	|	Ключ.Ссылка 				КАК Ссылка,
	|	Ключ.СтавкаНДС 				КАК СтавкаНДС
	|ИЗ
	|	Справочник.КлючиАналитикиУчетаПартий 			КАК Ключ
	|ГДЕ
	|	Ключ.НалоговоеНазначение 	  	= &НалоговоеНазначение
	|	И Ключ.Поставщик 			  	= &Поставщик
	|	И Ключ.Поставщик 			  	= &Поставщик
	|	И Ключ.Контрагент 			  	= &Контрагент
	|	И Ключ.СтавкаНДС 			  	= &СтавкаНДС
	|	И Ключ.ГруппаФинансовогоУчета 	= &ГруппаФинансовогоУчета
	|	И НЕ Ключ.ПометкаУдаления
	|");
	
	Запрос.УстановитьПараметр("НалоговоеНазначение"		, СтруктураАналитикУчетаПартий.НалоговоеНазначение);
	Запрос.УстановитьПараметр("Поставщик"				, СтруктураАналитикУчетаПартий.Поставщик);
	Запрос.УстановитьПараметр("Контрагент"				, СтруктураАналитикУчетаПартий.Контрагент);
	Запрос.УстановитьПараметр("ГруппаФинансовогоУчета"	, СтруктураАналитикУчетаПартий.ГруппаФинансовогоУчета);
	Запрос.УстановитьПараметр("СтавкаНДС"				, СтруктураАналитикУчетаПартий.СтавкаНДС);

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Ссылка;
	Иначе
		Результат = Справочники.КлючиАналитикиУчетаПартий.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат;
		
КонецФункции

Функция СоздатьКлючАналитики(ПараметрыАналитики)

	МенеджерЗаписи = РегистрыСведений.АналитикаУчетаПартий.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ПараметрыАналитики);
		
	Результат = НайтиАналитикуУчетаПартий(ПараметрыАналитики);
	
	// Создание нового ключа аналитики.
	Если Не ЗначениеЗаполнено(Результат) Тогда
		СправочникОбъект = Справочники.КлючиАналитикиУчетаПартий.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(СправочникОбъект, ПараметрыАналитики);
		СправочникОбъект.Наименование = ПолучитьНаименованиеКлючаАналитикиУчетаПартий(СправочникОбъект);
		СправочникОбъект.Записать();

		Результат = СправочникОбъект.Ссылка;
	КонецЕсли;

	МенеджерЗаписи.КлючАналитики = Результат;
	МенеджерЗаписи.Записать(Ложь);

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ЗаменаДублейКлючейАналитики

Процедура ЗаменитьДублиКлючейАналитики() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеСправочника.Ссылка 			КАК Ссылка,
	|	ДанныеСправочника.ПометкаУдаления 	КАК ПометкаУдаления,
	|	Аналитика.КлючАналитики 			КАК КлючАналитики
	|ИЗ
	|	Справочник.КлючиАналитикиУчетаПартий КАК ДанныеСправочника
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаПартий КАК ДанныеРегистра
	|	ПО
	|		ДанныеСправочника.Ссылка = ДанныеРегистра.КлючАналитики
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаПартий КАК Аналитика
	|	ПО
	|		ДанныеСправочника.ГруппаФинансовогоУчета = Аналитика.ГруппаФинансовогоУчета
	|		И ДанныеСправочника.Поставщик 			 = Аналитика.Поставщик
	|		И ДанныеСправочника.Контрагент			 = Аналитика.Контрагент
	|		И ДанныеСправочника.НалоговоеНазначение  = Аналитика.НалоговоеНазначение
	|		И ДанныеСправочника.СтавкаНДС 			 = Аналитика.СтавкаНДС
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

#КонецЕсли
