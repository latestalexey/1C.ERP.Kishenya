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
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
	
	ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеДляПроведения[7], Ссылка);
	
	РазрядыКатегорииДолжностей.СформироватьДвиженияРазрядовКатегорийСотрудников(Движения, ДанныеДляПроведения[6]);
	РазрядыКатегорииДолжностей.СформироватьДвиженияПКУСотрудников(Движения, ДанныеДляПроведения[8]);
	
	Если ИзменитьНачисления Тогда
		
		СтруктураПлановыхНачислений = Новый Структура;
		СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеДляПроведения[0]);
		СтруктураПлановыхНачислений.Вставить("ЗначенияПоказателей", ДанныеДляПроведения[1]);
		СтруктураПлановыхНачислений.Вставить("ПрименениеДополнительныхПоказателей", ДанныеДляПроведения[3]);
		
		РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений, Истина);
		РасчетЗарплатыРасширенный.СформироватьДвиженияПорядкаПересчетаТарифныхСтавок(Движения, ДанныеДляПроведения[4]);
		РасчетЗарплатыРасширенный.СформироватьДвиженияЗначенийСовокупныхТарифныхСтавок(Движения, ДанныеДляПроведения[5]);
		
	КонецЕсли;
	
	Если ИзменитьАванс Тогда
		РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат(Движения, ДанныеДляПроведения[2])
	КонецЕсли;
	
	//Категория ЕСВ
	Если ИзменитьКатегорияЕСВ Тогда
		СтруктураЕСВСотрудников = Новый Структура;
		СтруктураЕСВСотрудников.Вставить("ДанныеОЕСВСотрудников", ДанныеДляПроведения[9]);
		УчетСтраховыхВзносов.СформироватьДвиженияКатегорииЕСВ(ЭтотОбъект, Движения, СтруктураЕСВСотрудников);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Грейды") Тогда 
		Модуль = ОбщегоНазначения.ОбщийМодуль("Грейды");
		Модуль.СформироватьДвиженияГрейдовСотрудников(Движения, ДанныеДляПроведения[10]);
	КонецЕсли;
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= ДатаИзменения;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= ДатаИзменения;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект"));
	
	КадровыйУчетРасширенный.ПроверкаСпискаНачисленийКадровогоДокумента(ЭтотОбъект, ДатаИзменения, "Начисления", "Показатели", Отказ, Истина);
	
	Если ИзменитьНачисления Тогда 
		РасчетЗарплатыРасширенный.ПроверитьМножественностьОплатыВремениРаботникВШапке(ДатаИзменения, Сотрудник, Начисления, Ссылка, Отказ);
		РасчетЗарплатыРасширенный.ПроверитьУникальностьЗапрашиванияПоказателяСотрудникВШапке(Начисления.Выгрузить(), Показатели.Выгрузить(), Сотрудник, ДатаИзменения, Ссылка, Отказ);
		ПараметрыОтображенияПолейТарифнойСтавки = ЗарплатаКадрыРасширенный.ПараметрыОтображенияТарифнойСтавкиСотрудникВШапке(Сотрудник, Начисления);
		Если Не ПараметрыОтображенияПолейТарифнойСтавки.НесколькоТарифныхСтавок Тогда 
			ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "СовокупнаяТарифнаяСтавка");
		КонецЕсли;
		ЗарплатаКадрыРасширенный.ПроверитьЗаполнениеВидаТарифнойСтавки(ЭтотОбъект, Отказ);
	Иначе 
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "СовокупнаяТарифнаяСтавка");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетовПриОтменеПроведения(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Необходимо получить данные для формирования движений
//		кадровой истории - см. КадровыйУчетРасширенный.СформироватьКадровыеДвижения
//		плановых начислений - см. РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений
//		плановых выплат (авансы) - см. РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат.
// 
Функция ПолучитьДанныеДляПроведения()
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзменениеОплатыТрудаНачисления.Ссылка,
		|	ИзменениеОплатыТрудаНачисления.ИдентификаторСтрокиВидаРасчета
		|ПОМЕСТИТЬ ВТИспользуемыеНачисления
		|ИЗ
		|	Документ.ИзменениеОплатыТруда.Начисления КАК ИзменениеОплатыТрудаНачисления
		|ГДЕ
		|	ИзменениеОплатыТрудаНачисления.Ссылка = &Ссылка
		|	И ИзменениеОплатыТрудаНачисления.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ИзменениеОплатыТрудаПоказатели.Ссылка,
		|	ИзменениеОплатыТрудаПоказатели.Показатель
		|ПОМЕСТИТЬ ВТПоказателиНачислений
		|ИЗ
		|	ВТИспользуемыеНачисления КАК ИспользуемыеНачисления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеОплатыТруда.Показатели КАК ИзменениеОплатыТрудаПоказатели
		|		ПО ИспользуемыеНачисления.Ссылка = ИзменениеОплатыТрудаПоказатели.Ссылка
		|			И ИспользуемыеНачисления.ИдентификаторСтрокиВидаРасчета = ИзменениеОплатыТрудаПоказатели.ИдентификаторСтрокиВидаРасчета";
	
	Запрос.Выполнить();
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо,
		|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
		|	ИзменениеОплатыТрудаНачисления.Начисление,
		|	ИзменениеОплатыТрудаНачисления.ДокументОснование,
		|	ВЫБОР
		|		КОГДА ИзменениеОплатыТрудаНачисления.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Используется,
		|	ИзменениеОплатыТруда.ФизическоеЛицо,
		|	ИзменениеОплатыТруда.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ИзменениеОплатыТрудаНачисления.Размер,
		|	ИзменениеОплатыТрудаНачисления.ХарактерНачисления
		|ИЗ
		|	Документ.ИзменениеОплатыТруда.Начисления КАК ИзменениеОплатыТрудаНачисления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
		|		ПО ИзменениеОплатыТрудаНачисления.Ссылка = ИзменениеОплатыТруда.Ссылка
		|ГДЕ
		|	ИзменениеОплатыТруда.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеОплатыТруда.Организация КАК Организация,
		|	ИзменениеОплатыТруда.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
		|	ИзменениеОплатыТрудаПоказатели.Показатель,
		|	ИзменениеОплатыТрудаНачисления.ДокументОснование КАК ДокументОснование,
		|	ИзменениеОплатыТрудаПоказатели.Значение,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо,
		|	ИзменениеОплатыТрудаНачисления.ХарактерНачисления
		|ИЗ
		|	Документ.ИзменениеОплатыТруда.Показатели КАК ИзменениеОплатыТрудаПоказатели
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеОплатыТруда.Начисления КАК ИзменениеОплатыТрудаНачисления
		|		ПО ИзменениеОплатыТрудаПоказатели.Ссылка = ИзменениеОплатыТрудаНачисления.Ссылка
		|			И ИзменениеОплатыТрудаПоказатели.ИдентификаторСтрокиВидаРасчета = ИзменениеОплатыТрудаНачисления.ИдентификаторСтрокиВидаРасчета
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
		|		ПО ИзменениеОплатыТрудаПоказатели.Ссылка = ИзменениеОплатыТруда.Ссылка
		|ГДЕ
		|	ИзменениеОплатыТруда.Ссылка = &Ссылка
		|	И ИзменениеОплатыТрудаНачисления.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ИзменениеОплатыТрудаПоказатели.Ссылка.ДатаИзменения,
		|	ИзменениеОплатыТрудаПоказатели.Ссылка.Организация,
		|	ИзменениеОплатыТрудаПоказатели.Ссылка.ФизическоеЛицо,
		|	ИзменениеОплатыТрудаПоказатели.Ссылка.Сотрудник,
		|	ИзменениеОплатыТрудаПоказатели.Показатель,
		|	НЕОПРЕДЕЛЕНО,
		|	ИзменениеОплатыТрудаПоказатели.Значение,
		|	ДАТАВРЕМЯ(1, 1, 1),
		|	NULL
		|ИЗ
		|	Документ.ИзменениеОплатыТруда.Показатели КАК ИзменениеОплатыТрудаПоказатели
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиНачислений КАК ПоказателиНачислений
		|		ПО ИзменениеОплатыТрудаПоказатели.Ссылка = ПоказателиНачислений.Ссылка
		|			И ИзменениеОплатыТрудаПоказатели.Показатель = ПоказателиНачислений.Показатель
		|ГДЕ
		|	ИзменениеОплатыТрудаПоказатели.Ссылка = &Ссылка
		|	И ИзменениеОплатыТрудаПоказатели.ИдентификаторСтрокиВидаРасчета = 0
		|	И ИзменениеОплатыТрудаПоказатели.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|	И ИзменениеОплатыТрудаПоказатели.Показатель <> ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)
		|	И ПоказателиНачислений.Показатель ЕСТЬ NULL 
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
		|	ИзменениеОплатыТруда.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ЗНАЧЕНИЕ(ПЕРЕЧИСЛЕНИЕ.ВидыКадровыхСобытий.Перемещение) КАК ВидСобытия,
		|	ИзменениеОплатыТруда.СпособРасчетаАванса КАК СпособРасчетаАванса,
		|	ИзменениеОплатыТруда.Аванс КАК Аванс,
		|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
		|ГДЕ
		|	ИзменениеОплатыТруда.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИзменениеОплатыТрудаПоказатели.Ссылка.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеОплатыТрудаПоказатели.Ссылка.Организация КАК Организация,
		|	ИзменениеОплатыТрудаПоказатели.Ссылка.Сотрудник КАК Сотрудник,
		|	ИзменениеОплатыТрудаПоказатели.Ссылка.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ИзменениеОплатыТрудаПоказатели.Показатель КАК Показатель,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо,
		|	ВЫБОР
		|		КОГДА ИзменениеОплатыТрудаПоказатели.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Применение
		|ИЗ
		|	Документ.ИзменениеОплатыТруда.Показатели КАК ИзменениеОплатыТрудаПоказатели
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиНачислений КАК ПоказателиНачислений
		|		ПО ИзменениеОплатыТрудаПоказатели.Ссылка = ПоказателиНачислений.Ссылка
		|			И ИзменениеОплатыТрудаПоказатели.Показатель = ПоказателиНачислений.Показатель
		|ГДЕ
		|	ИзменениеОплатыТрудаПоказатели.Ссылка = &Ссылка
		|	И ИзменениеОплатыТрудаПоказатели.ИдентификаторСтрокиВидаРасчета = 0
		|	И ИзменениеОплатыТрудаПоказатели.Показатель <> ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)
		|	И ПоказателиНачислений.Показатель ЕСТЬ NULL 
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
		|	ИзменениеОплатыТруда.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ИзменениеОплатыТруда.ПорядокРасчетаСтоимостиЕдиницыВремени КАК ПорядокРасчета,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
		|ГДЕ
		|	ИзменениеОплатыТруда.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
		|	ИзменениеОплатыТруда.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ИзменениеОплатыТруда.СовокупнаяТарифнаяСтавка КАК Значение,
		|	ВЫБОР
		|		КОГДА ИзменениеОплатыТруда.СовокупнаяТарифнаяСтавка = 0
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыТарифныхСтавок.ПустаяСсылка)
		|		ИНАЧЕ ИзменениеОплатыТруда.ВидТарифнойСтавки
		|	КОНЕЦ КАК ВидТарифнойСтавки,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
		|ГДЕ
		|	ИзменениеОплатыТруда.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
		|	ИзменениеОплатыТруда.РазрядКатегория КАК РазрядКатегория,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
		|ГДЕ
		|	ИзменениеОплатыТруда.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник
		|ИЗ
		|	Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
		|ГДЕ
		|	ИзменениеОплатыТруда.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
		|	ИзменениеОплатыТруда.ПКУ КАК ПКУ,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
		|ГДЕ
		|	ИзменениеОплатыТруда.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИзменениеОплатыТруда.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеОплатыТруда.Сотрудник КАК Сотрудник,
		|	ИзменениеОплатыТруда.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ИзменениеОплатыТруда.КатегорияЕСВ КАК КатегорияЕСВ
		|ИЗ
		|	Документ.ИзменениеОплатыТруда КАК ИзменениеОплатыТруда
		|ГДЕ
		|	ИзменениеОплатыТруда.Ссылка = &Ссылка";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ДанныеДляПроведения = Новый Массив; 
	
	// Первый набор данных для проведения - таблица для формирования плановых начислений
	// см. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений.
	Если ИзменитьНачисления Тогда
		ПлановыеНачисления = РезультатыЗапроса[0].Выгрузить();
	Иначе	
		ПлановыеНачисления = Неопределено;
	КонецЕсли;
	
	ДанныеДляПроведения.Добавить(ПлановыеНачисления);
	
	// Второй набор данных для проведения - таблица значений показателей расчета зарплаты
	// см. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений.
	Если ИзменитьНачисления Тогда
		ЗначенияПоказателей = РезультатыЗапроса[1].Выгрузить();
	Иначе	
		ЗначенияПоказателей = Неопределено;
	КонецЕсли;

	ДанныеДляПроведения.Добавить(ЗначенияПоказателей);
	
	// Третий набор данных для проведения - таблица значений формирования движений по авансам
	// см. описание РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат.
	Если ИзменитьАванс Тогда
		ПлановыеАвансы = РезультатыЗапроса[2].Выгрузить();
	Иначе	
		ПлановыеАвансы = Неопределено;
	КонецЕсли;
	
	ДанныеДляПроведения.Добавить(ПлановыеАвансы);
	
	// Четвертый набор данных для проведения - таблица применения дополнительных показателей
	// см. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений.
	Если ИзменитьНачисления Тогда
		ПрименениеДополнительныхПоказателей = РезультатыЗапроса[3].Выгрузить();
	Иначе 
		ПрименениеДополнительныхПоказателей = Неопределено;
	КонецЕсли;
	
	ДанныеДляПроведения.Добавить(ПрименениеДополнительныхПоказателей);
	
	// Пятый набор данных для проведения - таблица значений порядка пересчета тарифной ставки
	// см. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПорядкаПересчетаТарифныхСтавок.
	Если ИзменитьНачисления Тогда
		ПорядокПересчетаТарифнойСтавки = РезультатыЗапроса[4].Выгрузить();
	Иначе 
		ПорядокПересчетаТарифнойСтавки = Неопределено;
	КонецЕсли;
	
	ДанныеДляПроведения.Добавить(ПорядокПересчетаТарифнойСтавки);
	
	// Шестой набор данных для проведения - таблица значений совокупной тарифной ставки
	// см. описание РасчетЗарплатыРасширенный.СформироватьДвиженияЗначенийСовокупныхТарифныхСтавок.
	Если ИзменитьНачисления Тогда
		ДанныеСовокупныхТарифныхСтавок = РезультатыЗапроса[5].Выгрузить();
	Иначе 
		ДанныеСовокупныхТарифныхСтавок = Неопределено;
	КонецЕсли;
	
	ДанныеДляПроведения.Добавить(ДанныеСовокупныхТарифныхСтавок);
	
	// Седьмой набор данных для проведения - таблица значений разряда сотрудника
	// см. описание РазрядыКатегорииДолжностей.СформироватьДвиженияРазрядовКатегорийСотрудников.
	РазрядыКатегорииСотрудников = РезультатыЗапроса[6].Выгрузить();
	
	ДанныеДляПроведения.Добавить(РазрядыКатегорииСотрудников);
	
	// Восьмой набор данных для проведения - для формирования времени регистрации документа
	// см. описание ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента.
	СотрудникиДаты = РезультатыЗапроса[7].Выгрузить();
	
	ДанныеДляПроведения.Добавить(СотрудникиДаты);
	
	// Девятый набор данных для проведения - таблица значений ПКУ сотрудника
	// см. описание РазрядыКатегорииДолжностей.СформироватьДвиженияПКУСотрудников.
	ПКУСотрудников = РезультатыЗапроса[8].Выгрузить();
	
	ДанныеДляПроведения.Добавить(ПКУСотрудников);
	
	// Десятый набор данных для проведения - категории ЕСВ
	ЕСВСотрудников = РезультатыЗапроса[9].Выгрузить();
	ДанныеДляПроведения.Добавить(ЕСВСотрудников);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Грейды") Тогда 
		Модуль = ОбщегоНазначения.ОбщийМодуль("Грейды");
		ДанныеГрейдовСотрудников = Модуль.ДанныеДляПроведенияГрейдыСотрудников(Ссылка, "ДатаИзменения");
		ДанныеДляПроведения.Добавить(ДанныеГрейдовСотрудников);
	КонецЕсли;
	
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура СоздатьВТДанныеДокументов(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Организация,
		|	ТаблицаДокумента.Сотрудник,
		|	НАЧАЛОПЕРИОДА(ТаблицаДокумента.ДатаИзменения, МЕСЯЦ) КАК ПериодДействия,
		|	ТаблицаДокумента.Ссылка КАК ДокументОснование
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.ИзменениеОплатыТруда КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор";
		
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли