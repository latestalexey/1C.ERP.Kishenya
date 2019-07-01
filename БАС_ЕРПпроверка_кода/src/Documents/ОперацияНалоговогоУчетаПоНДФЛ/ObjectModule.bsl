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
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "Сотрудник");
	
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, , Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
	
	УчетНДФЛ.СформироватьДоходыНДФЛПоКодамДоходовИзТаблицыЗначенийПолной(Движения, Отказ, Организация, ДатаОперации, ДанныеДляПроведения.Доходы);
	УчетНДФЛ.СформироватьИсчисленныйНалогПоВременнойТаблице(Движения, Отказ, Организация, ДатаОперации, ДанныеДляПроведения.МенеджерВременныхТаблиц);
	УчетНДФЛ.СформироватьУдержанныйНалогПоВременнойТаблице(Движения, Отказ, Организация, ДатаОперации, ДанныеДляПроведения.МенеджерВременныхТаблиц);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если СведенияОДоходах.Количество() = 0
		И НДФЛИсчисленный.Количество() = 0
		И НДФЛУдержанный.Количество() = 0
		Тогда
		
		СообщениеОбОшибке = НСтр("ru='Не заполнены табличные части, должна быть заполнена хотя бы одна табличная часть.';uk='Не заповнені табличні частини, має бути заповнено хоча б одна таблична частина.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,,,Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОперацияНалоговогоУчетаПоНДФЛСведенияОДоходах.Ссылка.Сотрудник КАК ФизическоеЛицо,
	|	ОперацияНалоговогоУчетаПоНДФЛСведенияОДоходах.КодДохода,
	|	ОперацияНалоговогоУчетаПоНДФЛСведенияОДоходах.СуммаДохода,
	|	НАЧАЛОПЕРИОДА(ОперацияНалоговогоУчетаПоНДФЛСведенияОДоходах.НалоговыйПериод, МЕСЯЦ) КАК НалоговыйПериод,
	|	ОперацияНалоговогоУчетаПоНДФЛСведенияОДоходах.ГруппаУчетаНачислений,
	|	ОперацияНалоговогоУчетаПоНДФЛСведенияОДоходах.НатуральныйКоэффициент
	|ПОМЕСТИТЬ ВТСведенияОДоходахПоНДФЛ
	|ИЗ
	|	Документ.ОперацияНалоговогоУчетаПоНДФЛ.СведенияОДоходах КАК ОперацияНалоговогоУчетаПоНДФЛСведенияОДоходах
	|ГДЕ
	|	ОперацияНалоговогоУчетаПоНДФЛСведенияОДоходах.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛИсчисленный.Ссылка.Сотрудник КАК ФизическоеЛицо,
	|	НАЧАЛОПЕРИОДА(ОперацияНалоговогоУчетаПоНДФЛНДФЛИсчисленный.НалоговыйПериод, МЕСЯЦ) КАК НалоговыйПериод,
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛИсчисленный.Налог,
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛИсчисленный.Доход,
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛИсчисленный.ВидСтавки,
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛИсчисленный.УвеличеннаяСтавка,
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛИсчисленный.Льгота,
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛИсчисленный.КоличествоЛьгот,
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛИсчисленный.СуммаЛьготы,
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛИсчисленный.КодДохода,
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛИсчисленный.ДоходПолный
	|ПОМЕСТИТЬ ВТНДФЛИсчисленный
	|ИЗ
	|	Документ.ОперацияНалоговогоУчетаПоНДФЛ.НДФЛИсчисленный КАК ОперацияНалоговогоУчетаПоНДФЛНДФЛИсчисленный
	|ГДЕ
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛИсчисленный.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛУдержанный.Ссылка.Сотрудник КАК ФизическоеЛицо,
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛУдержанный.ОбособленноеПодразделение,
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛУдержанный.КодДохода,
	|	НАЧАЛОПЕРИОДА(ОперацияНалоговогоУчетаПоНДФЛНДФЛУдержанный.НалоговыйПериод, МЕСЯЦ) КАК НалоговыйПериод,
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛУдержанный.Налог,
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛУдержанный.Доход,
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛУдержанный.ПериодВзаиморасчетов
	|ПОМЕСТИТЬ ВТНалогУдержанный
	|ИЗ
	|	Документ.ОперацияНалоговогоУчетаПоНДФЛ.НДФЛУдержанный КАК ОперацияНалоговогоУчетаПоНДФЛНДФЛУдержанный
	|ГДЕ
	|	ОперацияНалоговогоУчетаПоНДФЛНДФЛУдержанный.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СведенияОДоходахПоНДФЛ.ФизическоеЛицо,
	|	СведенияОДоходахПоНДФЛ.КодДохода,
	|	СведенияОДоходахПоНДФЛ.СуммаДохода,
	|	СведенияОДоходахПоНДФЛ.НалоговыйПериод,
	|	СведенияОДоходахПоНДФЛ.ГруппаУчетаНачислений,
	|	СведенияОДоходахПоНДФЛ.НатуральныйКоэффициент
	|ИЗ
	|	ВТСведенияОДоходахПоНДФЛ КАК СведенияОДоходахПоНДФЛ
	|ГДЕ
	|	(СведенияОДоходахПоНДФЛ.СуммаДохода <> 0)
	|;
	|";
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Доходы = Результаты[3].Выгрузить();
	
	ДанныеДляПроведения = Новый Структура("Доходы, МенеджерВременныхТаблиц", Доходы, Запрос.МенеджерВременныхТаблиц);
						
	Возврат ДанныеДляПроведения;

КонецФункции

#КонецОбласти

#КонецЕсли
