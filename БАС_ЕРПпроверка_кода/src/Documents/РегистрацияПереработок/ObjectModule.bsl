#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Подсистема "Управление доступом".

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическиеЛица.ФизическоеЛицо");
	
КонецПроцедуры
// Подсистема "Управление доступом".

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда 
		// Сверхурочные суммированного учета.
		ЗаписатьЗначенияПоказателейРасчетаЗарплаты(ЗначенияПоказателейСверхурочных(), Движения, Отказ);
		// Отгулы
		УчетРабочегоВремени.ЗарегистрироватьДниЧасыОтгуловСотрудников(Движения, ДанныеОбОтгулах());
	КонецЕсли;
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= НачалоМесяца(ПериодСуммированногоУчетаНачало);
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= КонецМесяца(ПериодСуммированногоУчетаОкончание);
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		Сотрудники.ВыгрузитьКолонку("Сотрудник"),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект.Сотрудники"));
	
	Ошибки = Неопределено;
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Для каждого Сотрудник Из Сотрудники Цикл
		ОбщееКоличествоПереработок = Сотрудник.ОтработаноЧасов-Сотрудник.НормаЧасов;
		СуммаВведенныхПереработок = Сотрудник.ОтработаноЧасов-Сотрудник.НормаЧасов;
		Если ОбщееКоличествоПереработок <> СуммаВведенныхПереработок Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
				Ошибки, "Объект.Сотрудники[%1].ОтработаноЧасов",
				НСтр("ru='Сумма сверхурочных часов не равна разнице между отработанным и нормо временем.';uk='Сума понаднормових годин не дорівнює різниці між відпрацьованим і нормо часом.'"), "", Сотрудники.Индекс(Сотрудник));
		КонецЕсли;
	КонецЦикла; 
	
	МассивНепроверяемыхРеквизитов.Добавить("Сотрудники.НормаЧасов");
	МассивНепроверяемыхРеквизитов.Добавить("Сотрудники.ОтработаноЧасов");
	
	Если НЕ Ошибки = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	КонецЕсли;
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗначенияПоказателейСверхурочных()
	
	ОперативныеПоказатели = Новый ТаблицаЗначений;
	
	ПереработаноПоСуммированномуУчетуВПределах2Часов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ПоказателиРасчетаЗарплаты.ПереработаноПоСуммированномуУчетуВПределах2Часов");
	ПереработаноПоСуммированномуУчету = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ПоказателиРасчетаЗарплаты.ПереработаноПоСуммированномуУчету");

	Если ПереработаноПоСуммированномуУчетуВПределах2Часов = Неопределено ИЛИ ПереработаноПоСуммированномуУчету = Неопределено Тогда
		Возврат ОперативныеПоказатели;
	КонецЕсли;
	
	ОперативныеПоказатели.Колонки.Добавить("ПериодДействия", Новый ОписаниеТипов("Дата"));
	ОперативныеПоказатели.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ОперативныеПоказатели.Колонки.Добавить("Показатель", Новый ОписаниеТипов("СправочникСсылка.ПоказателиРасчетаЗарплаты"));
	ОперативныеПоказатели.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ОперативныеПоказатели.Колонки.Добавить("Значение", Новый ОписаниеТипов("Число"));
	
	Для каждого Сотрудник Из Сотрудники Цикл
		Если Сотрудник.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.Отгул") Тогда
			Продолжить;
		КонецЕсли;
		Если Сотрудник.Сверхурочно1_5 > 0 Тогда
			ОперативныйПоказатель = ОперативныеПоказатели.Добавить();
			ОперативныйПоказатель.ПериодДействия = ПериодСуммированногоУчетаОкончание;
			ОперативныйПоказатель.Сотрудник = Сотрудник.Сотрудник;
			ОперативныйПоказатель.Показатель = ПереработаноПоСуммированномуУчетуВПределах2Часов;
			ОперативныйПоказатель.Организация = Организация;
			ОперативныйПоказатель.Значение = Сотрудник.Сверхурочно1_5;
		КонецЕсли;
		Если Сотрудник.Сверхурочно1_5 + Сотрудник.Сверхурочно2 > 0 Тогда
			ОперативныйПоказатель = ОперативныеПоказатели.Добавить();
			ОперативныйПоказатель.ПериодДействия = ПериодСуммированногоУчетаОкончание;
			ОперативныйПоказатель.Сотрудник = Сотрудник.Сотрудник;
			ОперативныйПоказатель.Показатель = ПереработаноПоСуммированномуУчету;
			ОперативныйПоказатель.Организация = Организация;
			ОперативныйПоказатель.Значение = Сотрудник.Сверхурочно1_5 + Сотрудник.Сверхурочно2;
		КонецЕсли;
	КонецЦикла; 	
	
	Возврат ОперативныеПоказатели;

КонецФункции

Процедура ЗаписатьЗначенияПоказателейРасчетаЗарплаты(ТаблицаЗначенийПоказателей, Движения, Отказ)
	
	Для Каждого СтрокаЗначений Из ТаблицаЗначенийПоказателей Цикл
		НаборЗаписей = Движения.ЗначенияРазовыхПоказателейРасчетаЗарплатыСотрудников;
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), СтрокаЗначений);
		НаборЗаписей.Записывать = Истина;
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьВТДанныеДокументов(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка.Организация КАК Организация,
		|	ТаблицаДокумента.Сотрудник,
		|	НАЧАЛОПЕРИОДА(ТаблицаДокумента.Ссылка.Дата, МЕСЯЦ) КАК ПериодДействия,
		|	ТаблицаДокумента.Ссылка КАК ДокументОснование
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.РегистрацияПереработок.Сотрудники КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор";
		
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ДанныеОбОтгулах()

	ТаблицаОтгулов = Новый ТаблицаЗначений;
	ТаблицаОтгулов.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаОтгулов.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаОтгулов.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	ТаблицаОтгулов.Колонки.Добавить("ВидДвижения", Новый ОписаниеТипов("ВидДвиженияНакопления"));
	ТаблицаОтгулов.Колонки.Добавить("Дни", Новый ОписаниеТипов("Число"));
	ТаблицаОтгулов.Колонки.Добавить("Часы", Новый ОписаниеТипов("Число"));
	
	Для Каждого СтрокаТаблицы Из Сотрудники Цикл
		Если НЕ СтрокаТаблицы.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.Отгул") Тогда 
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ТаблицаОтгулов.Добавить();
		НоваяСтрока.Период = КонецМесяца(ПериодСуммированногоУчетаОкончание);
		НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Приход;
		НоваяСтрока.Организация = Организация;
		НоваяСтрока.Сотрудник = СтрокаТаблицы.Сотрудник;
		НоваяСтрока.Дни = 0; 
		НоваяСтрока.Часы = СтрокаТаблицы.Сверхурочно1_5 + СтрокаТаблицы.Сверхурочно2;
	КонецЦикла;

	Возврат ТаблицаОтгулов;
	
КонецФункции

#КонецОбласти

#КонецЕсли