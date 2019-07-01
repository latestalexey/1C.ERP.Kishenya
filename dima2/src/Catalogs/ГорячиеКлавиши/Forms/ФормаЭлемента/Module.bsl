
&НаКлиенте
Перем КэшированныеЗначения;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТаблицаБыстрыеТовары = Объект.Ссылка.БыстрыеТовары.Получить();
		Если ТаблицаБыстрыеТовары <> Неопределено Тогда
			БыстрыеТовары.Загрузить(ТаблицаБыстрыеТовары);
		КонецЕсли;
		
		ТаблицаКомандыФормы = Объект.Ссылка.КомандыФормы.Получить();
		Если ТаблицаКомандыФормы <> Неопределено Тогда
			КомандыФормы.Загрузить(ТаблицаКомандыФормы);
		КонецЕсли;
		
		КоличествоБыстрыхТоваров = БыстрыеТовары.Количество();
		КоличествоКомандФормы = КомандыФормы.Количество();
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьПоУмолчаниюНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Для Каждого СтрокаТЧ Из БыстрыеТовары Цикл
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Клавиша) Тогда
			СтрокаТЧ.Клавиша = Строка(Клавиша.Нет);
		КонецЕсли;
	КонецЦикла;
	Для Каждого СтрокаТЧ Из КомандыФормы Цикл
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Клавиша) Тогда
			СтрокаТЧ.Клавиша = Строка(Клавиша.Нет);
		КонецЕсли;
	КонецЦикла;
	
	ТекущийОбъект.БыстрыеТовары  = Новый ХранилищеЗначения(БыстрыеТовары.Выгрузить());
	ТекущийОбъект.КомандыФормы = Новый ХранилищеЗначения(КомандыФормы.Выгрузить());

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЧтениеКомандФормы"
		И Параметр.Форма = УникальныйИдентификатор Тогда
		
		ЗаполнитьПоУмолчаниюНаСервере(Параметр.АдресВоВременномХранилище);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыБыстрыетовары

&НаКлиенте
Процедура БыстрыеТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.БыстрыеТовары.ТекущиеДанные;
	ТекущиеДанные.Заголовок = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				ТекущиеДанные.Номенклатура,
				ТекущиеДанные.Характеристика,
				ТекущиеДанные.Упаковка);
	
	ТекущаяСтрока = Элементы.БыстрыеТовары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);

	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "БыстрыеТовары"));

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыеТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.БыстрыеТовары.ТекущиеДанные;
	ТекущиеДанные.Заголовок = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				ТекущиеДанные.Номенклатура,
				ТекущиеДанные.Характеристика,
				ТекущиеДанные.Упаковка);
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыеТоварыУпаковкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.БыстрыеТовары.ТекущиеДанные;
	ТекущиеДанные.Заголовок = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				ТекущиеДанные.Номенклатура,
				ТекущиеДанные.Характеристика,
				ТекущиеДанные.Упаковка);
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыеТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.БыстрыеТоварыСочетаниеКлавиш = Поле Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ВозвращаемоеЗначение = Неопределено;

		
		ОткрытьФорму("Справочник.ГорячиеКлавиши.Форма.ФормаВыборСочетанияКлавиш", Новый Структура("Адрес", АдресВоВременномХранилище()),,,,, Новый ОписаниеОповещения("БыстрыеТоварыВыборЗавершение", ЭтотОбъект, Новый Структура("ВыбраннаяСтрока", ВыбраннаяСтрока)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыеТоварыВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ВыбраннаяСтрока = ДополнительныеПараметры.ВыбраннаяСтрока;
    
    
    ВозвращаемоеЗначение = Результат;
    
    Если ВозвращаемоеЗначение <> Неопределено Тогда
        
        ОчиститьСочетаниеКлавиш(ВозвращаемоеЗначение);
        
        ТекущаяСтрока = БыстрыеТовары.НайтиПоИдентификатору(ВыбраннаяСтрока);
        ТекущаяСтрока.СочетаниеКлавиш = ПредставлениеСочетанияКлавиш(ВозвращаемоеЗначение);
        
        ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ВозвращаемоеЗначение);
        Модифицированность = Истина;
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура БыстрыеТоварыПриИзменении(Элемент)
	КоличествоБыстрыхТоваров = БыстрыеТовары.Количество();
КонецПроцедуры

&НаКлиенте
Процедура БыстрыеТоварыПослеУдаления(Элемент)
	КоличествоБыстрыхТоваров = БыстрыеТовары.Количество();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКоманды

&НаКлиенте
Процедура КомандыФормыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.КомандыФормыСочетаниеКлавиш = Поле Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ВозвращаемоеЗначение = Неопределено;

		
		ОткрытьФорму("Справочник.ГорячиеКлавиши.Форма.ФормаВыборСочетанияКлавиш", Новый Структура("Адрес", АдресВоВременномХранилище()),,,,, Новый ОписаниеОповещения("КомандыФормыВыборЗавершение", ЭтотОбъект, Новый Структура("ВыбраннаяСтрока", ВыбраннаяСтрока)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандыФормыВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ВыбраннаяСтрока = ДополнительныеПараметры.ВыбраннаяСтрока;
    
    
    ВозвращаемоеЗначение = Результат;
    
    Если ВозвращаемоеЗначение <> Неопределено Тогда
        
        ОчиститьСочетаниеКлавиш(ВозвращаемоеЗначение);
        
        ТекущаяСтрока = КомандыФормы.НайтиПоИдентификатору(ВыбраннаяСтрока);
        ТекущаяСтрока.СочетаниеКлавиш = ПредставлениеСочетанияКлавиш(ВозвращаемоеЗначение);
        
        ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ВозвращаемоеЗначение);
        Модифицированность = Истина;
        
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоУмолчанию(Команда)
	
	ЗаполнитьПоУмолчаниюНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьВсеКоманды(Команда)
	
	Для Каждого СтрокаТЧ Из КомандыФормы Цикл
		СтрокаТЧ.Скрывать = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВсеКоманды(Команда)
	
	Для Каждого СтрокаТЧ Из КомандыФормы Цикл
		СтрокаТЧ.Скрывать = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, 
																   "БыстрыеТоварыНоменклатураЕдиницаИзмерения", 
                                                                   "БыстрыеТовары.Упаковка");

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "БыстрыеТоварыХарактеристика",
																		     "БыстрыеТовары.ХарактеристикиИспользуются");

КонецПроцедуры

#Область Прочее

&НаСервере
Функция НоваяКоманда(Таблица, ДанныеКоманды)
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Команда   = ДанныеКоманды.ИмяКоманды;
	НоваяСтрока.Заголовок = ДанныеКоманды.Заголовок;
	НоваяСтрока.Клавиша   = ДанныеКоманды.СочетаниеКлавиш.Клавиша;
	НоваяСтрока.Alt       = ДанныеКоманды.СочетаниеКлавиш.Alt;
	НоваяСтрока.Ctrl      = ДанныеКоманды.СочетаниеКлавиш.Ctrl;
	НоваяСтрока.Shift     = ДанныеКоманды.СочетаниеКлавиш.Shift;
	
	НоваяСтрока.СочетаниеКлавиш = ПредставлениеСочетанияКлавиш(ДанныеКоманды.СочетаниеКлавиш);
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПоУмолчаниюНаКлиенте()
	
	ФормаДокументаЧекККМ = ПолучитьФорму("Документ.ЧекККМ.Форма.ФормаДокументаРМК", Новый Структура("Основание, АвтоТест", Новый Структура("ЧтениеКомандФормы")));
	Оповестить("ЧтениеКомандФормы", Новый Структура("Форма, ФормаВладелец", ФормаДокументаЧекККМ.УникальныйИдентификатор, УникальныйИдентификатор));
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеСочетанияКлавиш(Сочетание)
	
	Возврат ОбщегоНазначенияУТ.ПредставлениеСочетанияКлавиш(Сочетание, Истина);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПоУмолчаниюНаСервере(АдресВоВременномХранилище)
	
	КомандыФормы.Очистить();
	
	ТаблицаКомандыФормы = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	Для Каждого КомандаФормы Из ТаблицаКомандыФормы Цикл
		НоваяСтрока = НоваяКоманда(КомандыФормы, КомандаФормы);
	КонецЦикла;
	
	КоличествоКомандФормы = КомандыФормы.Количество();
	
КонецПроцедуры

&НаСервере
Функция АдресВоВременномХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(
		Новый Структура(
			"БыстрыеТовары, КомандыФормы", БыстрыеТовары.Выгрузить(), КомандыФормы.Выгрузить()
		),
		УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ОчиститьСочетаниеКлавиш(СочетаниеКлавиш)
	
	ПредставлениеСочетанияКлавиш = ПредставлениеСочетанияКлавиш(СочетаниеКлавиш);
	
	Для Каждого СтрокаТЧ Из БыстрыеТовары Цикл
		Если СтрокаТЧ.СочетаниеКлавиш = ПредставлениеСочетанияКлавиш Тогда
			СтрокаТЧ.Клавиша = Строка(Клавиша.Нет);
			СтрокаТЧ.Ctrl = Ложь;
			СтрокаТЧ.Shift = Ложь;
			СтрокаТЧ.Alt = Ложь;
			СтрокаТЧ.СочетаниеКлавиш = "";
		КонецЕсли;
	КонецЦикла;
	Для Каждого СтрокаТЧ Из КомандыФормы Цикл
		Если СтрокаТЧ.СочетаниеКлавиш = ПредставлениеСочетанияКлавиш Тогда
			СтрокаТЧ.Клавиша = Строка(Клавиша.Нет);
			СтрокаТЧ.Ctrl = Ложь;
			СтрокаТЧ.Shift = Ложь;
			СтрокаТЧ.Alt = Ложь;
			СтрокаТЧ.СочетаниеКлавиш = "";
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого СтрокаТЧ Из БыстрыеТовары Цикл
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Номенклатура) Тогда
			
			НомерСтроки = БыстрыеТовары.Индекс(СтрокаТЧ);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Не заполнено поле ""Номенклатура"" в строке %1';uk='Не заповнене поле ""Номенклатура"" в рядку %1'"),
					НомерСтроки + 1
				),,
				"БыстрыеТовары["+НомерСтроки+"].Номенклатура",,Отказ);
			
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Характеристика) И СтрокаТЧ.ХарактеристикиИспользуются Тогда
			
			НомерСтроки = БыстрыеТовары.Индекс(СтрокаТЧ);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Не заполнено поле ""Характеристика"" в строке %1';uk='Не заповнене поле ""Характеристика"" в рядку %1'"),
					НомерСтроки + 1
				),,
				"БыстрыеТовары["+НомерСтроки+"].Характеристика",,Отказ);
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#КонецОбласти
