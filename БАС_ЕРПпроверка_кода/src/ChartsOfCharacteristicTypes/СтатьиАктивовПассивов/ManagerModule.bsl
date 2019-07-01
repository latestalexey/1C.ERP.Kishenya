#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имена блокруемых реквизитов для механизма блокирования реквизитов БСП
//
// Возвращаемое значание:
//	Массив - имена блокируемых реквизитов
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("АктивПассив; АктивПассив");
	Результат.Добавить("ТипЗначения; ТипЗначения");
	
	Возврат Результат;
	
КонецФункции

// Функция определяет аналитику активов и пассивов для подстановки в документ по статье активов и пассивов.
//
// Параметры:
//  СтатьяАктивовПассивов - ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов - Ссылка на статью активов и пассивов
//	Объект - ДанныеФормыСтруктура - Текущий объект 
//
// Возвращаемое значение:
//	СправочникСсылка - значение аналитики по умолчанию для активов и пассивов
//
Функция ПолучитьАналитикуАктивовПассивовПоУмолчанию(СтатьяАктивовПассивов, Объект) Экспорт
	
	ОписаниеТипов = Новый ОписаниеТипов(СтатьяАктивовПассивов.ТипЗначения);
	АналитикаАктивовПассивов = ОписаниеТипов.ПривестиЗначение();
	
	Если СтатьяАктивовПассивов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Склады")
		И Объект.Свойство("Склад") Тогда
	
		АналитикаАктивовПассивов = Объект.Склад;
	
	ИначеЕсли СтатьяАктивовПассивов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Партнеры")
		И Объект.Свойство("Партнер") Тогда
		
		АналитикаАктивовПассивов = Объект.Партнер;
		
	ИначеЕсли СтатьяАктивовПассивов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Контрагенты")
		И Объект.Свойство("Контрагент") Тогда
		
		АналитикаАктивовПассивов = Объект.Контрагент;
		
	ИначеЕсли СтатьяАктивовПассивов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия")
		И Объект.Свойство("Подразделение") Тогда
		
		АналитикаАктивовПассивов = Объект.Подразделение;
		
	ИначеЕсли СтатьяАктивовПассивов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия")
		И Объект.Свойство("ПодразделениеПредприятия") Тогда
		
		АналитикаАктивовПассивов = Объект.ПодразделениеПредприятия;
		
	ИначеЕсли СтатьяАктивовПассивов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации")
		И Объект.Свойство("Организация") Тогда
	
		АналитикаАктивовПассивов = Объект.Организация;
		
	ИначеЕсли СтатьяАктивовПассивов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица")
		И Объект.Свойство("ФизическоеЛицо") Тогда
	
		АналитикаАктивовПассивов = Объект.ФизическоеЛицо;
		
	КонецЕсли;
	
	Возврат АналитикаАктивовПассивов;
	
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуКарточкаАктиваПассива(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.СписокФорм = "ФормаЭлемента";
	КонецЕсли;

КонецПроцедуры

// Возвращает статьи активов/пассивов, использование которых запрещено
//
// Возвращаемое значение:
// 	ЗаблокированныеСтатьи - СписокЗначений - Список заблокированных статей активов/пассивов
//
Функция ЗаблокированныеСтатьиАктивовПассивов() Экспорт
	
	ЗаблокированныеСтатьи = Новый СписокЗначений;
	ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиАктивовПассивов.ИмущественныеНалоги);		 // Использовать статью "Налоги"
	ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиАктивовПассивов.НалогиИВзносыСОплатыТруда); // Использовать статью "Налоги"
	
	Возврат ЗаблокированныеСтатьи;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТВызовСервера.ОбработкаПолученияДанныхВыбораПВХСтатьиАктивовПассивов(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура УстановитьПризнакАктивПассивУПредопределенныхЭлементов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатьиАктивовПассивов.Ссылка,
		|	ВЫБОР
		|		КОГДА СтатьиАктивовПассивов.Ссылка В (
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ВыданныеАвансы),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ЗадолженностьКлиентов),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ДенежныеСредстваБезналичные),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ДенежныеСредстваНаличные),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ДенежныеСредстваУПодотчетныхЛиц),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ДенежныеСредстваБезналичныеКПоступлению),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ДенежныеСредстваНаличныеКПоступлению),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ДепозитыВБанках),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ЗадолженностьСобственныхОрганизаций),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ЗаймыВыданные),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ПрочиеАктивы),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.РасходыБудущихПериодов),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.РасходыТекущегоПериода),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.НезавершенноеПроизводство),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ТоварыПереданныеВПереработку),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ТоварыВРознице),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ТоварыНаОптовыхСкладах),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ТоварыПереданныеВПереработку),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ПредметыЛизинга),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиАктивовПассивов.ТоварыПереданныеНаКомиссию))
		|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСтатейУправленческогоБаланса.Актив)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыСтатейУправленческогоБаланса.Пассив)
		|	КОНЕЦ КАК АктивПассив
		|ИЗ
		|	ПланВидовХарактеристик.СтатьиАктивовПассивов КАК СтатьиАктивовПассивов
		|ГДЕ
		|	СтатьиАктивовПассивов.Предопределенный
		|	И НЕ СтатьиАктивовПассивов.ЭтоГруппа
		|	И СтатьиАктивовПассивов.АктивПассив = ЗНАЧЕНИЕ(Перечисление.ВидыСтатейУправленческогоБаланса.ПустаяСсылка)";
		
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ПВХОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ПВХОбъект.АктивПассив = Выборка.АктивПассив;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ПВХОбъект);
	КонецЦикла;

КонецПроцедуры


// Обработчик обновления BAS УТ 3.2.2
// Вместо статей расходов с вариантом распределения "НаПрочиеАктивы" создает статьи активов/пассивов.
Процедура СоздатьСтатьиАктивовПассивовНаОснованииСтатейРасходов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтатьиРасходов.Ссылка КАК Ссылка,
	|	СтатьиРасходов.Наименование КАК Наименование,
	|	СтатьиРасходов.Описание КАК Описание,
	|	СтатьиРасходов.ПометкаУдаления КАК ПометкаУдаления
	|ПОМЕСТИТЬ СтатьиРасходов
	|ИЗ
	|	ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиРасходов
	|ГДЕ
	|	СтатьиРасходов.ВариантРаспределенияРасходов = &НаПрочиеАктивы
    |	И НЕ СтатьиРасходов.ВидЦенности В (&ВидыЦенностей)
	|	И НЕ СтатьиРасходов.Описание ПОДОБНО &ДополнениеОписания
	|	И НЕ СтатьиРасходов.ПометкаУдаления
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|ВЫБРАТЬ
	|	СтатьиРасходов.Ссылка КАК Ссылка,
	|	СтатьиРасходов.Наименование КАК Наименование,
	|	СтатьиРасходов.Описание КАК Описание,
	|	СтатьиРасходов.ПометкаУдаления КАК ПометкаУдаления
	|ИЗ
	|	СтатьиРасходов КАК СтатьиРасходов
	|
	|УПОРЯДОЧИТЬ ПО
	|	СтатьиРасходов.Ссылка
	|;
	|
	|ВЫБРАТЬ
	|	СтатьиРасходов.Ссылка КАК Владелец,
	|	ПрочиеАктивыПассивы.Ссылка КАК Ссылка
	|ИЗ
	|	СтатьиРасходов КАК СтатьиРасходов
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Справочник.ПрочиеАктивыПассивы КАК ПрочиеАктивыПассивы
	|	ПО
	|		СтатьиРасходов.Ссылка = ПрочиеАктивыПассивы.Владелец
	|
	|УПОРЯДОЧИТЬ ПО
	|	СтатьиРасходов.Ссылка
	|
	|ИТОГИ ПО
	|	СтатьиРасходов.Ссылка
	|";
	
	Запрос.УстановитьПараметр("НаПрочиеАктивы", Перечисления.ВариантыРаспределенияРасходов.НаПрочиеАктивы);
	
    ВидыЦенностей = Новый Массив;
	ВидыЦенностей.Добавить(Перечисления.ВидыЦенностей.ОС);
	ВидыЦенностей.Добавить(Перечисления.ВидыЦенностей.ОбъектыНезавершенногоСтроительства);
	ВидыЦенностей.Добавить(Перечисления.ВидыЦенностей.НМА);
    Запрос.УстановитьПараметр("ВидыЦенностей", ВидыЦенностей);
	
	ДополнениеОписания = НСтр("ru='#Статья активов/пассивов создана при обновлении#';uk='#Стаття активів/пасивів створена при оновленні#'");
	Запрос.УстановитьПараметр("ДополнениеОписания", "%" + ДополнениеОписания + "%");
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ВыборкаСтатьиРасходов = РезультатЗапроса[1].Выбрать();
	ВыборкаПрочиеАктивыПассивыИтоги = РезультатЗапроса[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаПрочиеАктивыПассивыИтоги.Следующий();
	
	Пока ВыборкаСтатьиРасходов.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			СтатьяАктивовПассивов = ПланыВидовХарактеристик.СтатьиАктивовПассивов.СоздатьЭлемент();
			СтатьяАктивовПассивов.Наименование = ВыборкаСтатьиРасходов.Наименование;
			СтатьяАктивовПассивов.Описание = ВыборкаСтатьиРасходов.Описание;
			СтатьяАктивовПассивов.ПометкаУдаления = ВыборкаСтатьиРасходов.ПометкаУдаления;
			СтатьяАктивовПассивов.АктивПассив = Перечисления.ВидыСтатейУправленческогоБаланса.Актив;
			СтатьяАктивовПассивов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ПрочиеАктивыПассивы"); 
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(СтатьяАктивовПассивов);
			
			СтатьяРасходов = ВыборкаСтатьиРасходов.Ссылка.ПолучитьОбъект();
			СтатьяРасходов.Описание = 
				НСтр("ru='Вместо данной статьи в документах следует использовать соответствующую статью активов/пассивов.';uk='Замість цієї статті в документах слід використовувати відповідну статтю активів/пасивів.'")
				+ Символы.ПС + ДополнениеОписания;
			Если ВыборкаСтатьиРасходов.Описание <> "" Тогда
				СтатьяРасходов.Описание = 
					СтатьяРасходов.Описание
					+ Символы.ПС + "-------------"
					+ Символы.ПС + ВыборкаСтатьиРасходов.Описание;
			КонецЕсли;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(СтатьяРасходов);
			
			Если ВыборкаСтатьиРасходов.Ссылка = ВыборкаПрочиеАктивыПассивыИтоги.Владелец Тогда
				ВыборкаПрочиеАктивыПассивы = ВыборкаПрочиеАктивыПассивыИтоги.Выбрать();
				Пока ВыборкаПрочиеАктивыПассивы.Следующий() Цикл
					ПрочиеАктивыПассивы = ВыборкаПрочиеАктивыПассивы.Ссылка.ПолучитьОбъект();
					ПрочиеАктивыПассивы.Владелец = СтатьяАктивовПассивов.Ссылка;
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(ПрочиеАктивыПассивы);
				КонецЦикла;
				ВыборкаПрочиеАктивыПассивыИтоги.Следующий();
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ШаблонСообщения = НСтр("ru='Не удалось обработать %1 по причине: %2';uk='Не вдалося обробити %1 з причини: %2'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								ШаблонСообщения, ВыборкаСтатьиРасходов.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())); 
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				ВыборкаСтатьиРасходов.Ссылка.Метаданные(),
				ВыборкаСтатьиРасходов.Ссылка,
				ТекстСообщения);
			ВызватьИсключение ТекстСообщения;
		КонецПопытки
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.2
// Включает использование учета прочих активов и пассивов
Процедура ВключитьИспользованиеУчетаПрочихАктивовПассивов() Экспорт
	
	// Проверим, используются ли прочие операции расхода/поступления денежных средств
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РасходныйКассовыйОрдер.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|ГДЕ
	|	РасходныйКассовыйОрдер.ХозяйственнаяОперация = &ПрочаяВыдачаДС
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СписаниеБезналичныхДенежныхСредств.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.СписаниеБезналичныхДенежныхСредств КАК СписаниеБезналичныхДенежныхСредств
	|ГДЕ
	|	СписаниеБезналичныхДенежныхСредств.ХозяйственнаяОперация = &ПрочаяВыдачаДС
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаявкаНаРасходованиеДенежныхСредств.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК ЗаявкаНаРасходованиеДенежныхСредств
	|ГДЕ
	|	ЗаявкаНаРасходованиеДенежныхСредств.ХозяйственнаяОперация = &ПрочаяВыдачаДС
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПриходныйКассовыйОрдер.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
	|ГДЕ
	|	ПриходныйКассовыйОрдер.ХозяйственнаяОперация = &ПрочееПосутуплениеДС
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПоступлениеБезналичныхДенежныхСредств.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ПоступлениеБезналичныхДенежныхСредств КАК ПоступлениеБезналичныхДенежныхСредств
	|ГДЕ
	|	ПоступлениеБезналичныхДенежныхСредств.ХозяйственнаяОперация = &ПрочееПосутуплениеДС
	|";
	
	Запрос.УстановитьПараметр("ПрочаяВыдачаДС", Перечисления.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств);
	Запрос.УстановитьПараметр("ПрочееПосутуплениеДС", Перечисления.ХозяйственныеОперации.ПрочееПоступлениеДенежныхСредств);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Константы.ИспользоватьУчетПрочихАктивовПассивов.Установить(Истина);
	КонецЕсли;
	
	// Удален предопределенный элемент статей расходов ПоступлениеОС.
	// В связи с этим при обновлении ИБ пометилась на удаление соответствующая статья расходов
	// Проверим - если статья расходов используется, то снимем пометку удаления
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтатьиРасходов.Ссылка КАК Ссылка
	|ИЗ
	|	ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиРасходов
	|ГДЕ
	|	СтатьиРасходов.Наименование = &ПоступлениеОС
	|	И СтатьиРасходов.ПометкаУдаления";
	Запрос.УстановитьПараметр("ПоступлениеОС", НСтр("ru='Поступление ОС';uk='Надходження ОЗ'"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Если ОбщегоНазначения.ЕстьСсылкиНаОбъект(Выборка.Ссылка) Тогда
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Объект.ПометкаУдаления = Ложь;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти

#КонецЕсли

