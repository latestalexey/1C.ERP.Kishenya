////////////////////////////////////////////////////////////////////////////////////////
// Модуль "КомиссионнаяТорговляКлиент", содержит процедуры и функции для 
// обработки действий пользователя в процессе работы с документами комиссионной торговли
//
////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийЭлементовФормы

// Процедура - обработчик события "ПриИзменении" поля "СтавкаНДСВознаграждения".
//
Процедура СтавкаНДСВознагражденияПриИзменении(Объект, ПроцентНДС) Экспорт
	
	ПроцентНДС = ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(Объект.СтавкаНДСВознаграждения);
	РассчитатьКомиссионноеВознаграждениеНДС(Объект, ПроцентНДС);
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля "СуммаПродажи" таблицы.
//
Процедура СуммаПродажиПриИзменении(СтрокаТаблицы, ЕстьСуммаПродажиНДС) Экспорт
	
	СтрокаТаблицы.ЦенаПродажи = ?(СтрокаТаблицы.КоличествоУпаковок <> 0, Окр(СтрокаТаблицы.СуммаПродажи / СтрокаТаблицы.КоличествоУпаковок, 2, 1), 0);
	Если ЕстьСуммаПродажиНДС Тогда
		СтрокаТаблицы.СуммаПродажиНДС = СуммаПродажиНДС(СтрокаТаблицы.СуммаПродажи, СтрокаТаблицы.СтавкаНДС);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля "Упаковка" таблицы.
//
Процедура ОтчетКомиссионераТоварыУпаковкаПриИзменении(Объект, ТекущаяСтрока, ИспользоватьСоглашенияСКлиентами, КэшированныеЗначения) Экспорт

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	Если ТекущаяСтрока.Количество > 0 Тогда
		СтруктураДействий.Вставить("ПересчитатьЦенуЗаУпаковку", ТекущаяСтрока.Количество);
	ИначеЕсли ИспользоватьСоглашенияСКлиентами И ЗначениеЗаполнено(Объект.Соглашение) Тогда
		СтруктураДействий.Вставить(
		   "ЗаполнитьУсловияПродаж", 
		   ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруЗаполненияУсловийПродажВСтрокеТЧ(Объект));
	ИначеЕсли ЗначениеЗаполнено(ТекущаяСтрока.ВидЦены) Тогда
		СтруктураДействий.Вставить(
		   "ЗаполнитьЦенуПродажи",
		   ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруЗаполненияЦеныВСтрокеТЧ(Объект));
	КонецЕсли;
	
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", 
	   ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект));
	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", Новый Структура("ЦенаВключаетНДС", Объект.ЦенаВключаетНДС));
	СтруктураДействий.Вставить("ПересчитатьЦенуПродажиЗаУпаковку");
	СтруктураДействий.Вставить("ПересчитатьСуммуПродажи");
	СтруктураДействий.Вставить("ПересчитатьСуммуПродажиНДС");
	СтруктураДействий.Вставить("ОчиститьСуммуВознаграждения");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля "КоличествоУпаковок" таблицы.
//
Процедура ОтчетКомиссионераТоварыКоличествоУпаковокПриИзменении(Объект, ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	Если Объект.ПоРезультатамИнвентаризации Тогда
		ТекущаяСтрока.КоличествоУпаковокФакт = ТекущаяСтрока.КоличествоУпаковокУчет - ТекущаяСтрока.КоличествоУпаковок;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СамообслуживаниеКлиентСервер.ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковокОтчетКомиссионера(СтруктураДействий, Объект);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля "ЦенаПродажи" таблицы.
//
Процедура ОтчетКомиссионераТоварыЦенаПродажиПриИзменении(ТекущаяСтрока, КэшированныеЗначения) Экспорт

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуПродажи");
	СтруктураДействий.Вставить("ПересчитатьСуммуПродажиНДС");
	СтруктураДействий.Вставить("ОчиститьСуммуВознаграждения");

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииПроверкиВозможностиВыполненияДействий

// Функция определяет необходимость расчета комиссионного вознаграждения.
//
Процедура НеобходимоРассчитатьВознаграждение(ОписаниеОповещения, Форма) Экспорт
	
	Если Форма.Объект.СпособРасчетаВознаграждения = ПредопределенноеЗначение("Перечисление.СпособыРасчетаКомиссионногоВознаграждения.НеРассчитывается") Тогда
		НеобходимоОчиститьКомиссионноеВознаграждение(ОписаниеОповещения, Форма);
	Иначе
		НеобходимоРассчитатьКомиссионноеВознаграждение(ОписаниеОповещения, Форма);
	КонецЕсли;
	
КонецПроцедуры

// Процедура выводит сообщения пользователю, если заполнение не было выполнено.
//
// Параметры:
//	Объект - ДанныеФорма - Текущий объект
//
Процедура ПроверитьЗаполнениеДокументаПоОстаткам(Объект) Экспорт
	
	Если Объект.Товары.Количество() = 0 Тогда
	   
		Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ОтчетКомитенту") Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Нет данных о продажах товаров комитента ""%1""';uk='Немає даних про продажі товарів комітента ""%1""'"),
				Объект.Партнер);
		ИначеЕсли ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ОтчетКомитентуОСписании") Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Нет данных о списании товаров комитента ""%1""';uk='Немає даних про списання товарів комітента ""%1""'"),
				Объект.Партнер);
		Иначе
			Текст = "";
		КонецЕсли;
				
		Если Не ПустаяСтрока(Текст) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				Объект.Ссылка,
				, // Поле
				// Отказ
			);
		КонецЕсли;
	   
	КонецЕсли;
	
КонецПроцедуры

// Проверяет заполненность реквизитов, необходимых для пересчета из валюты в валюту
//
// Параметры:
// Документ - ДокументОбъект, для которого выполняются проверки
// СтараяВалюта - Предыдущая валюта документа
//
// Возвращаемое значение:
//	Булево - Ложь, если необходимые данные не заполнены
//
Функция ПроверитьНеобходимостьПересчетаВВалютуОтчетыПоКомиссии(ОписаниеОповещения, Объект, СтараяВалюта) Экспорт
	
	Если ЗначениеЗаполнено(Объект.Валюта)
	   И ЗначениеЗаполнено(СтараяВалюта)
	   И СтараяВалюта <> Объект.Валюта
	   И (Объект.Товары.Итог("Цена") <> 0
	      ИЛИ Объект.Товары.Итог("СуммаПродажи") <> 0) Тогда
	
		ТекстСообщения = НСтр("ru='Пересчитать суммы в документе в валюту ""%Валюта%""?';uk='Перерахувати суми в документі в валюту ""%Валюта%""?'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Валюта%", Объект.Валюта);
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(Истина, НСтр("ru='Да';uk='Так'"));
		Кнопки.Добавить(Ложь, НСтр("ru='Нет';uk='Ні'"));
		
		ПоказатьВопрос(
			ОписаниеОповещения,
			ТекстСообщения,
			Кнопки,
			,
			Истина);
		
	Иначе
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Ложь);
		
	КонецЕсли;

КонецФункции

#КонецОбласти

#Область ПроцедурыОповещенияПользователяОВыполненныхДействиях

// Процедура показывает оповещение пользователю об окончании расчета
// комиссионного вознаграждения.
//
Процедура ОповеститьОбОкончанииРасчетаВознаграждения(СпособРасчетаВознаграждения) Экспорт
	
	Если СпособРасчетаВознаграждения = ПредопределенноеЗначение("Перечисление.СпособыРасчетаКомиссионногоВознаграждения.НеРассчитывается") Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru='Вознаграждение очищено';uk='Винагорода очищена'"),
			,
			НСтр("ru='Комиссионное вознаграждение в документе очищено';uk='Комісійна винагорода в документі очищена'"),
			БиблиотекаКартинок.Информация32);
	Иначе
		ПоказатьОповещениеПользователя(
			НСтр("ru='Вознаграждение рассчитано';uk='Винагорода розрахована'"),
			,
			НСтр("ru='Комиссионное вознаграждение в документе рассчитано';uk='Комісійна винагорода в документі розрахована'"),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Процедура рассчитывает сумму НДС комиссионного вознаграждения.
//
Процедура РассчитатьКомиссионноеВознаграждениеНДС(Объект, ПроцентНДС) Экспорт
	
	Объект.СуммаНДСВознаграждения = Окр(Объект.СуммаВознаграждения * ПроцентНДС / (1 + ПроцентНДС), 2, РежимОкругления.Окр15как20);
	
КонецПроцедуры

// Процедура заполняет поле "Дата платежа" в документе.
//
// Параметры:
//	ДатаПлатежа - Дата
//	ПараметрыЗаписи - Структура - Параметры записи документа
//
Процедура ЗаполнитьДатуПлатежа(ОписаниеОповещения, ДатаПлатежа, ПараметрыЗаписи) Экспорт
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение
	 И Не ЗначениеЗаполнено(ДатаПлатежа) Тогда
		ПоказатьВводДаты(ОписаниеОповещения, ДатаПлатежа, НСтр("ru='Введите дату платежа';uk='Введіть дату платежу'"), ЧастиДаты.Дата);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, ДатаПлатежа);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НеобходимоРассчитатьКомиссионноеВознаграждение(ОписаниеОповещения, Форма)
	
	Если Форма.Объект.Товары.Количество() > 0 Тогда
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(Истина, НСтр("ru='Да';uk='Так'"));
		Кнопки.Добавить(Ложь, НСтр("ru='Нет';uk='Ні'"));
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);
		ДополнительныеПараметры.Вставить("Форма", Форма);
		ПоказатьВопрос(
			Новый ОписаниеОповещения("НеобходимоРассчитатьКомиссионноеВознаграждениеВопросЗавершение", КомиссионнаяТорговляКлиент, ДополнительныеПараметры),
			НСтр("ru='Рассчитать комиссионное вознаграждение?';uk='Розрахувати комісійну винагороду?'"),
			Кнопки,,
			Истина);
		
	Иначе
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Ложь);
		
	КонецЕсли;
	
КонецФункции

Процедура НеобходимоРассчитатьКомиссионноеВознаграждениеВопросЗавершение(НеобходимоРассчитать, ДополнительныеПараметры) Экспорт
	
	Если НеобходимоРассчитать Тогда
		
		Если ДополнительныеПараметры.Форма.Объект.ПроцентВознаграждения = 0 Тогда
			ПоказатьВводЧисла(
				Новый ОписаниеОповещения("НеобходимоРассчитатьКомиссионноеВознаграждениеВвестиПроцентВознагражденияЗавершение", КомиссионнаяТорговляКлиент, ДополнительныеПараметры),
				ДополнительныеПараметры.Форма.Объект.ПроцентВознаграждения,
				НСтр("ru='Введите процент вознаграждения';uk='Введіть відсоток винагороди'"),
				5, 2); 
				
		Иначе
			
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, Истина);
			
		КонецЕсли;
		
	Иначе
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура НеобходимоРассчитатьКомиссионноеВознаграждениеВвестиПроцентВознагражденияЗавершение(ПроцентВознаграждения, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.Форма.Объект.ПроцентВознаграждения = ПроцентВознаграждения;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, Истина);
	
КонецПроцедуры

Функция НеобходимоОчиститьКомиссионноеВознаграждение(ОписаниеОповещения, Форма)
	
	Если Форма.Объект.Товары.Итог("СуммаВознаграждения") <> 0 Тогда
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(Истина, НСтр("ru='Да';uk='Так'"));
		Кнопки.Добавить(Ложь, НСтр("ru='Нет';uk='Ні'"));
		
		ПоказатьВопрос(
			ОписаниеОповещения,
			НСтр("ru='Комиссионное вознаграждение будет очищено, продолжить?';uk='Комісійна винагорода буде очищена, продовжити?'"),
			Кнопки,,
			Истина);
		
	Иначе
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Ложь);
		
	КонецЕсли;
	
КонецФункции

Функция СуммаПродажиНДС(СуммаПродажи, СтавкаНДС)
	
	ТекущийПроцентНДС = ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(СтавкаНДС);
	СуммаПродажиНДС = Окр(СуммаПродажи * ТекущийПроцентНДС / (1 + ТекущийПроцентНДС), 2, РежимОкругления.Окр15как20);
	
	Возврат СуммаПродажиНДС;
	
КонецФункции

#КонецОбласти
