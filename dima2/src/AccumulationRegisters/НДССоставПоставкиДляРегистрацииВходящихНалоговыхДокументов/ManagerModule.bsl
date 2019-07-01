#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Функция ПолноеИмяРегистра()
    Возврат "РегистрНакопления.НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов";
КонецФункции 

Функция ИмяРегистра()
    Возврат СтрЗаменить(ПолноеИмяРегистра(), "РегистрНакопления.", "");
КонецФункции 

Процедура ЗаменитьАналитикуУчетаПоПартнерам_ДанныеДляОбновления(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра();
	
#Область АналитикаУчетаПоПартнерам

	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Расчеты.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов КАК Расчеты
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Аналитика
	|		ПО Расчеты.АналитикаУчетаПоПартнерам = Аналитика.КлючАналитики
	|			И (Аналитика.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка))
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК Договоры
	|		ПО (Договоры.Ссылка = 
	|				ВЫБОР КОГДА Расчеты.ОбъектРасчетов ССЫЛКА Справочник.ДоговорыКонтрагентов
	|					ТОГДА Расчеты.ОбъектРасчетов
    |               КОГДА Расчеты.ОбъектРасчетов = НЕОПРЕДЕЛЕНО ТОГДА НЕОПРЕДЕЛЕНО
	|				ИНАЧЕ Расчеты.ОбъектРасчетов.Договор
	|			КОНЕЦ)
	|ГДЕ
	|	    Расчеты.Регистратор ССЫЛКА Документ.АвансовыйОтчет
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ВозвратТоваровМеждуОрганизациями
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ВозвратТоваровОтКлиента
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ВозвратТоваровПоставщику
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ОтчетКомиссионера
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ОтчетКомитенту
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ОтчетПоКомиссииМеждуОрганизациями
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ПередачаТоваровМеждуОрганизациями
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг
    |	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ПоступлениеУслугПрочихАктивов
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг
    |	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.РегистрацияВходящегоНалоговогоДокумента
	|");
    
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Регистраторы, ДополнительныеПараметры);
	
#КонецОбласти

КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.3
// Производит замену измерения "АналитикаУчетаПоПартнерам" с учетом договора.
Процедура ЗаменитьАналитикуУчетаПоПартнерам(Параметры) Экспорт
    
    МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
    
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуРегистраторовРегистраДляОбработки(
	     Параметры.Очередь,
	     Неопределено,
	     ПолноеИмяРегистра(),
	     МенеджерВременныхТаблиц
    );
	
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
    КонецЕсли;
    
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
    КонецЕсли; 
    
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.АналитикаУчетаПоПартнерам                    КАК КлючСтаройАналитики,
	|	ДанныеРегистра.ОбъектРасчетов                               КАК ОбъектРасчетов,
	|	ЕСТЬNULL(НоваяАналитикаУчетаПоПартнерам.КлючАналитики, НЕОПРЕДЕЛЕНО) КАК КлючНовойАналитики,
	|	СтараяАналитикаРегистраУчетаПоПартнерам.Организация         КАК Организация,
	|	СтараяАналитикаРегистраУчетаПоПартнерам.Партнер             КАК Партнер,
	|	СтараяАналитикаРегистраУчетаПоПартнерам.Контрагент          КАК Контрагент,
	|	СтараяАналитикаРегистраУчетаПоПартнерам.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|   ВЫБОР КОГДА ДанныеРегистра.ОбъектРасчетов ССЫЛКА Справочник.ДоговорыКонтрагентов
	|	    ТОГДА ДанныеРегистра.ОбъектРасчетов
	|	ИНАЧЕ ДанныеРегистра.ОбъектРасчетов.Договор КОНЕЦ           КАК Договор
	|ИЗ
	|	ВТДляОбработки КАК СписокРегистраторов
	|	
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.КнигаДоходовРасходовПоЕдиномуНалогу КАК ДанныеРегистра
	|		ПО ДанныеРегистра.Регистратор = СписокРегистраторов.Регистратор
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК СтараяАналитикаРегистраУчетаПоПартнерам
	|		ПО ДанныеРегистра.АналитикаУчетаПоПартнерам = СтараяАналитикаРегистраУчетаПоПартнерам.КлючАналитики
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК НоваяАналитикаУчетаПоПартнерам
	|		ПО СтараяАналитикаРегистраУчетаПоПартнерам.Партнер = НоваяАналитикаУчетаПоПартнерам.Партнер
	|			И СтараяАналитикаРегистраУчетаПоПартнерам.Организация = НоваяАналитикаУчетаПоПартнерам.Организация
	|			И СтараяАналитикаРегистраУчетаПоПартнерам.Контрагент = НоваяАналитикаУчетаПоПартнерам.Контрагент
	|			И СтараяАналитикаРегистраУчетаПоПартнерам.НаправлениеДеятельности = НоваяАналитикаУчетаПоПартнерам.НаправлениеДеятельности
	|			И НоваяАналитикаУчетаПоПартнерам.Договор = (
    |               ВЫБОР КОГДА ДанныеРегистра.ОбъектРасчетов ССЫЛКА Справочник.ДоговорыКонтрагентов
	|	                ТОГДА ДанныеРегистра.ОбъектРасчетов
	|	            ИНАЧЕ ДанныеРегистра.ОбъектРасчетов.Договор КОНЕЦ)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокРегистраторов.Регистратор КАК Ссылка
	|ИЗ
	|	ВТДляОбработки КАК СписокРегистраторов
	|";
    
    ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "РегистрНакопления.КнигаДоходовРасходовПоЕдиномуНалогу", ПолноеИмяРегистра());
    ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВТДляОбработки", Результат.ИмяВременнойТаблицы);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.ВыполнитьПакет();
	
	ТаблицаАналитик = Результат[0].Выгрузить();
	Для Каждого СтрокаАналитики Из ТаблицаАналитик Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаАналитики.КлючНовойАналитики) Тогда
			НоваяАналитика = РегистрыСведений.АналитикаУчетаПоПартнерам.ЗначениеКлючаАналитики(СтрокаАналитики);
			СтрокаАналитики.КлючНовойАналитики = НоваяАналитика;
		КонецЕсли;
	КонецЦикла;
	
	РеквизитыПоиска = "КлючСтаройАналитики, ОбъектРасчетов";
	ТаблицаАналитик.Индексы.Добавить(РеквизитыПоиска);
	СтруктураПоиска = Новый Структура(РеквизитыПоиска);
	
	Выборка = Результат[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра() + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
		
			НаборЗаписей = РегистрыНакопления[ИмяРегистра()].СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Ссылка);
			НаборЗаписей.Прочитать();
			
			Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
				
				СтруктураПоиска.Вставить("КлючСтаройАналитики", ЗаписьНабора.АналитикаУчетаПоПартнерам);
				СтруктураПоиска.Вставить("ОбъектРасчетов", ЗаписьНабора.ОбъектРасчетов);
				МассивСтрок = ТаблицаАналитик.НайтиСтроки(СтруктураПоиска);
				
				// Отсутствует аналитика в РС АналитикаУчетаПоПартнерам
				Если МассивСтрок.Количество() = 0 Тогда
					ТекстСообщения = НСтр("ru='Не удалось дополнить аналитику %Аналитика% по партнерам договором при обработке документа: %Ссылка% по причине: %Причина%';uk='Не вдалося доповнити аналітику %Аналитика% партнерам договором при обробці документа: %%Посилання% по причині: %Причина%'");
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%"   , Выборка.Ссылка);
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Аналитика%", ЗаписьНабора.АналитикаУчетаПоПартнерам);
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%"  , "Отсутствует сведения об аналитике в регистре сведений ""Аналитика учета по партнерам""");
			
					ЗаписьЖурналаРегистрации(
                        ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
                        УровеньЖурналаРегистрации.Предупреждение,
						Выборка.Ссылка.Метаданные(), 
                        Выборка.Ссылка, 
                        ТекстСообщения
                    );
				Иначе
				
					ЗаписьНабора.АналитикаУчетаПоПартнерам = МассивСтрок[0].КлючНовойАналитики;
				
				КонецЕсли;
				
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			
			ЗафиксироватьТранзакцию();
		
		Исключение
		
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru='Не удалось дополнить аналитику по партнерам договором при обработке документа: %Ссылка% по причине: %Причина%';uk='Не вдалося доповнити аналітику за партнерами договором при обробці документа: %Ссылка% по причині: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
                ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
                УровеньЖурналаРегистрации.Предупреждение,
				Выборка.Ссылка.Метаданные(), 
                Выборка.Ссылка, 
                ТекстСообщения
            );
            
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
        Параметры.Очередь, 
        ПолноеИмяРегистра()
    );
    
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.4
Процедура ОбновитьПриходныеДвиженияНДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов_ДанныеДляОбновления(Параметры) Экспорт
	
	ДополнительныеПараметрыОтметки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметрыОтметки.ЭтоДвижения = Истина;
	ДополнительныеПараметрыОтметки.ПолноеИмяРегистра = ПолноеИмяРегистра();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов.Регистратор
	|ИЗ
	|	РегистрНакопления.НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов КАК НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов
	|ГДЕ
	|	НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	И НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов.НалоговоеНазначение = ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка)
	|	И ТИПЗНАЧЕНИЯ(НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов.Регистратор) <> ТИП(Документ.КорректировкаРегистров)";
	
	ДанныеКОбработке = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ДанныеКОбработке, ДополнительныеПараметрыОтметки);
	
КонецПроцедуры

Процедура ОбновитьПриходныеДвиженияНДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ВозвратТоваровМеждуОрганизациями");
	Регистраторы.Добавить("Документ.ВозвратТоваровПоставщику");
	Регистраторы.Добавить("Документ.ОтчетКомиссионера");
	Регистраторы.Добавить("Документ.ОтчетКомитенту");
	Регистраторы.Добавить("Документ.ОтчетПоКомиссииМеждуОрганизациями");
	Регистраторы.Добавить("Документ.ПередачаТоваровМеждуОрганизациями");
	Регистраторы.Добавить("Документ.ПоступлениеТоваровУслуг");
	Регистраторы.Добавить("Документ.ПоступлениеУслугПрочихАктивов");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
        Регистраторы,
		ПолноеИмяРегистра(),
		Параметры.Очередь
    );
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

Процедура ОбновитьРасходныеДвиженияНДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов_ДанныеДляОбновления(Параметры) Экспорт
	
	ДополнительныеПараметрыОтметки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметрыОтметки.ЭтоДвижения = Истина;
	ДополнительныеПараметрыОтметки.ПолноеИмяРегистра = ПолноеИмяРегистра();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов.Регистратор
	|ИЗ
	|	РегистрНакопления.НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов КАК НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов
	|ГДЕ
	|	НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	И НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов.НалоговоеНазначение = ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка)
	|	И ТИПЗНАЧЕНИЯ(НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов.Регистратор) <> ТИП(Документ.КорректировкаРегистров)";
	
	ДанныеКОбработке = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ДанныеКОбработке, ДополнительныеПараметрыОтметки);
	
КонецПроцедуры

Процедура ОбновитьРасходныеДвиженияНДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.РегистрацияВходящегоНалоговогоДокумента");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
        Регистраторы,
		ПолноеИмяРегистра(),
		Параметры.Очередь
    );
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.7
//
// Исправление ошибки 53661: "При ведении расчетов по договорам в регистре накопления НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов 
// документа ВозвратТоваровПоставщику ошибочно может не заполняться объект расчетов."
//
// Исправление ошибки 53544: "Документ РегистрацияВходящегоНалоговогоДокумента  делает движения по регистрам
// НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов, НДСРеестрПолученныхНалоговыхДокументов по Договору из закладки Дополнительно."
//
Процедура ИсправитьДвиженияПоРегистраторамВовзратТоваровПоставщикуИРВНД(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ВозвратТоваровПоставщику");
	Регистраторы.Добавить("Документ.РегистрацияВходящегоНалоговогоДокумента");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
        Регистраторы,
		ПолноеИмяРегистра(),
		Параметры.Очередь
    );
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

Процедура ИсправитьДвиженияПоРегистраторамВовзратТоваровПоставщикуИРВНД_ДанныеДляОбновления(Параметры) Экспорт

	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НДСРасчетНалоговогоКредита.Регистратор,
	|	НДСРасчетНалоговогоКредита.АналитикаУчетаПоПартнерам,
	|	НДСРасчетНалоговогоКредита.ОбъектРасчетов,
	|	НДСРасчетНалоговогоКредита.ВидПоставки,
	|	1 КАК ЗнакРегистра
	|ПОМЕСТИТЬ ВТНДСРасчетНК
	|ИЗ
	|	РегистрНакопления.НДСРасчетНалоговогоКредита КАК НДСРасчетНалоговогоКредита
	|ГДЕ
	|	НДСРасчетНалоговогоКредита.СуммаПоставкиТребующаяРегистрацииНН <> 0
	|	И ТИПЗНАЧЕНИЯ(НДСРасчетНалоговогоКредита.Регистратор) = ТИП(Документ.ВозвратТоваровПоставщику)
	|	И ВЫРАЗИТЬ(НДСРасчетНалоговогоКредита.Регистратор КАК Документ.ВозвратТоваровПоставщику).ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровПоставщику)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов.Регистратор,
	|	НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов.АналитикаУчетаПоПартнерам,
	|	НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов.ОбъектРасчетов,
	|	НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов.ВидПоставки,
	|	-1 КАК ЗнакРегистра
	|ПОМЕСТИТЬ ВТНДССоставПоставки
	|ИЗ
	|	РегистрНакопления.НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов КАК НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов.Регистратор) = ТИП(Документ.ВозвратТоваровПоставщику)
	|	И ВЫРАЗИТЬ(НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов.Регистратор КАК Документ.ВозвратТоваровПоставщику).ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровПоставщику)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(ВТНДСРасчетНК.Регистратор, ВТНДССоставПоставки.Регистратор) КАК Ссылка
	|ИЗ
	|	ВТНДСРасчетНК КАК ВТНДСРасчетНК
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТНДССоставПоставки КАК ВТНДССоставПоставки
	|		ПО ВТНДСРасчетНК.Регистратор = ВТНДССоставПоставки.Регистратор
	|			И ВТНДСРасчетНК.АналитикаУчетаПоПартнерам = ВТНДССоставПоставки.АналитикаУчетаПоПартнерам
	|			И ВТНДСРасчетНК.ОбъектРасчетов = ВТНДССоставПоставки.ОбъектРасчетов
	|			И ВТНДСРасчетНК.ВидПоставки = ВТНДССоставПоставки.ВидПоставки
	|ГДЕ
	|	ЕСТЬNULL(ВТНДСРасчетНК.ЗнакРегистра, 0) + ЕСТЬNULL(ВТНДССоставПоставки.ЗнакРегистра, 0) <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НДССоставПоставки.Регистратор
	|ИЗ
	|	РегистрНакопления.НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов КАК НДССоставПоставки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.НДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов.Остатки КАК НДССоставПоставкиОстаток
	|		ПО НДССоставПоставки.АналитикаУчетаПоПартнерам = НДССоставПоставкиОстаток.АналитикаУчетаПоПартнерам
	|			И НДССоставПоставки.ОбъектРасчетов = НДССоставПоставкиОстаток.ОбъектРасчетов
	|			И НДССоставПоставки.ВидПоставки = НДССоставПоставкиОстаток.ВидПоставки
	|			И НДССоставПоставки.СтавкаНДС = НДССоставПоставкиОстаток.СтавкаНДС
	|			И НДССоставПоставки.НалоговоеНазначение = НДССоставПоставкиОстаток.НалоговоеНазначение
	|ГДЕ
	|	НДССоставПоставки.Регистратор ССЫЛКА Документ.РегистрацияВходящегоНалоговогоДокумента
	|	И ТИПЗНАЧЕНИЯ(НДССоставПоставки.Регистратор) <> ТИП(Документ.КорректировкаРегистров)";
	
	ДанныеКОбработке = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(
		Параметры,
		ДанныеКОбработке,
		ДополнительныеПараметры);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
