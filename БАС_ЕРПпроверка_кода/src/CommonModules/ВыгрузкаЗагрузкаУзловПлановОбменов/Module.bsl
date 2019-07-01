// Заполняет массив типов, для которых при выгрузке необходимо использовать аннотацию
// ссылок в файлах выгрузки.
//
// Параметры:
//  Типы - Массив(ОбъектМетаданных)
//
Процедура ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы) Экспорт
	
	Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
		
		Типы.Добавить(ПланОбмена);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриРегистрацииОбработчиковВыгрузкиДанных(ТаблицаОбработчиков) Экспорт
	
	Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
		
		НовыйОбработчик = ТаблицаОбработчиков.Добавить();
		НовыйОбработчик.ОбъектМетаданных = ПланОбмена;
		НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаУзловПлановОбменов;
		НовыйОбработчик.ПередВыгрузкойОбъекта = Истина;
		НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередВыгрузкойОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты, Отказ) Экспорт
	
	ОбъектМетаданных = Объект.Метаданные();
	
	Если ОбщегоНазначенияБТС.ЭтоПланОбмена(ОбъектМетаданных) Тогда
		
		// Поддерживается сопоставление ссылок на узлы ЭтотУзел при загрузке данных
		
		Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
		ЭтотУзел = Менеджер.ЭтотУзел();
		
		Если Объект.Ссылка = ЭтотУзел Тогда
			
			ЕстественныйКлюч = Новый Структура("ЭтотУзел", Истина);
			МенеджерВыгрузкиОбъекта.ТребуетсяСопоставитьСсылкуПриЗагрузке(Объект.Ссылка, ЕстественныйКлюч);
			
		КонецЕсли;
		
		// Выгрузка / загрузка узлов планов обмена не поддерживается.
		
		Отказ = Истина;
		
	Иначе
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru='Объект метаданных %1 не может быть обработан обработчиком
                  |ВыгрузкаЗагрузкаУзловПлановОбменов.ПередВыгрузкойОбъекта()!'
                  |;uk='Об''єкт метаданих %1 не може бути оброблений обробником
                  |ВыгрузкаЗагрузкаУзловПлановОбменов.ПередВыгрузкойОбъекта()!'",Метаданные.ОсновнойЯзык.КодЯзыка),
			Объект.Метаданные().ПолноеИмя()
		);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриРегистрацииОбработчиковЗагрузкиДанных(ТаблицаОбработчиков) Экспорт
	
	НовыйОбработчик = ТаблицаОбработчиков.Добавить();
	НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаУзловПлановОбменов;
	НовыйОбработчик.ПередЗагрузкойДанных = Истина;
	НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
	
	Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
		
		НовыйОбработчик = ТаблицаОбработчиков.Добавить();
		НовыйОбработчик.ОбъектМетаданных = ПланОбмена;
		НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаУзловПлановОбменов;
		НовыйОбработчик.ПередСопоставлениемСсылок = Истина;
		НовыйОбработчик.ПередЗагрузкойОбъекта = Истина;
		НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗагрузкойДанных(Контейнер) Экспорт
	
	Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
		
		ТекстЗапроса = "Выбрать Первые 1 Ссылка Из ПланОбмена." + ПланОбмена.Имя;
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.Выполнить().Выбрать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередСопоставлениемСсылок(Контейнер, ОбъектМетаданных, ТаблицаИсходныхСсылок, СтандартнаяОбработка, Отказ) Экспорт
	
	Если ОбщегоНазначенияБТС.ЭтоПланОбмена(ОбъектМетаданных) И ТаблицаИсходныхСсылок.Колонки.Найти("ЭтотУзел") <> Неопределено Тогда
		
		СтандартнаяОбработка = Ложь
		
	КонецЕсли;
	
КонецПроцедуры

Функция СопоставитьСсылки(Контейнер, МенеджерСопоставленияСсылок, ТаблицаИсходныхСсылок) Экспорт
	
	ИсходныеСсылкиДляСтандартнойОбработки = Новый ТаблицаЗначений();
	Для Каждого Колонка Из ТаблицаИсходныхСсылок.Колонки Цикл
		Если Колонка.Имя <> "ЭтотУзел" Тогда
			ИсходныеСсылкиДляСтандартнойОбработки.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения);
		КонецЕсли;
	КонецЦикла;
	
	ИмяКолонки = МенеджерСопоставленияСсылок.ИмяКолонкиИсходныхСсылок();
	
	Результат = Новый ТаблицаЗначений();
	Результат.Колонки.Добавить(ИмяКолонки, ТаблицаИсходныхСсылок.Колонки.Найти(ИмяКолонки).ТипЗначения);
	Результат.Колонки.Добавить("Ссылка", ТаблицаИсходныхСсылок.Колонки.Найти(ИмяКолонки).ТипЗначения);
	
	ОбъектМетаданных = Неопределено;
	
	Для Каждого СтрокаТаблицыИсходныхСсылок Из ТаблицаИсходныхСсылок Цикл
		
		Если СтрокаТаблицыИсходныхСсылок.ЭтотУзел Тогда
			
			ОбъектМетаданных = СтрокаТаблицыИсходныхСсылок[ИмяКолонки].Метаданные();
			Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
			НоваяСсылка = Менеджер.ЭтотУзел();
			
			СтрокаРезультата = Результат.Добавить();
			СтрокаРезультата.Ссылка = НоваяСсылка;
			СтрокаРезультата[ИмяКолонки] = СтрокаТаблицыИсходныхСсылок[ИмяКолонки];
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИсходныеСсылкиДляСтандартнойОбработки.Количество() > 0 Тогда
		
		Выборка = Обработки.ВыгрузкаЗагрузкаДанныхМенеджерСопоставленияСсылок.ВыборкаСопоставленияСсылок(
			ОбъектМетаданных, ИсходныеСсылкиДляСтандартнойОбработки, ИмяКолонки);
		
		Пока Выборка.Следующий() Цикл
			
			СтрокаРезультата = Результат.Добавить();
			СтрокаРезультата.Ссылка = Выборка.Ссылка;
			СтрокаРезультата[ИмяКолонки] = Выборка[ИмяКолонки];
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПередЗагрузкойОбъекта(Контейнер, Объект, Артефакты, Отказ) Экспорт
	
	ОбъектМетаданных = Объект.Метаданные();
	
	Если ОбщегоНазначенияБТС.ЭтоПланОбмена(ОбъектМетаданных) Тогда
		
		Отказ = Истина; // Загрузка узлов планов обмена не поддерживается
		
	Иначе
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru='Объект метаданных %1 не может быть обработан обработчиком
                  |ВыгрузкаЗагрузкаУзловПлановОбменов.ПередЗагрузкойОбъекта()!'
                  |;uk='Об''єкт метаданих %1 не може бути оброблений обробником
                  |ВыгрузкаЗагрузкаУзловПлановОбменов.ПередЗагрузкойОбъекта()!'",Метаданные.ОсновнойЯзык.КодЯзыка),
			Объект.Метаданные().ПолноеИмя()
		);
		
	КонецЕсли;
	
КонецПроцедуры


