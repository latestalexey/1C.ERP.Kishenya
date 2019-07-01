#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Функция ПолноеИмяРегистра()
    Возврат "РегистрНакопления.НДСНоменклатурныйСоставДляНалоговыхНакладных";
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
	|	РегистрНакопления.НДСНоменклатурныйСоставДляНалоговыхНакладных КАК Расчеты
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
	|	    Расчеты.Регистратор ССЫЛКА Документ.АктВыполненныхРабот
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ВозвратТоваровМеждуОрганизациями
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ВозвратТоваровОтКлиента
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.НалоговаяНакладная
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ОтчетКомиссионера
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ОтчетКомитенту
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ОтчетОРозничныхПродажах
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ОтчетПоКомиссииМеждуОрганизациями
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ПередачаТоваровМеждуОрганизациями
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.Приложение2КНалоговойНакладной
	|	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг
    |	ИЛИ Расчеты.Регистратор ССЫЛКА Документ.РеализацияУслугПрочихАктивов
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

// Обработчик обновления BAS УТ 3.2.7
Процедура ИсправитьДвиженияПоРегистраторуВозвратТоваровОтКлиента(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ВозвратТоваровОтКлиента");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
        Регистраторы,
		ПолноеИмяРегистра(),
		Параметры.Очередь
    );
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

Процедура ИсправитьДвиженияПоРегистраторуВозвратТоваровОтКлиента_ДанныеДляОбновления(Параметры) Экспорт

	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НДСРасчетНалоговыхОбязательств.Регистратор,
	|	НДСРасчетНалоговыхОбязательств.АналитикаУчетаПоПартнерам,
	|	НДСРасчетНалоговыхОбязательств.ОбъектРасчетов,
	|	НДСРасчетНалоговыхОбязательств.ВидПоставки,
	|	1 КАК ЗнакРегистра
	|ПОМЕСТИТЬ ВТНДСРасчетНО
	|ИЗ
	|	РегистрНакопления.НДСРасчетНалоговыхОбязательств КАК НДСРасчетНалоговыхОбязательств
	|ГДЕ
	|	НДСРасчетНалоговыхОбязательств.СуммаПоставкиТребующаяРегистрацииНН <> 0
	|	И ТИПЗНАЧЕНИЯ(НДСРасчетНалоговыхОбязательств.Регистратор) = ТИП(Документ.ВозвратТоваровОтКлиента)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НДСНоменклатурныйСоставДляНалоговыхНакладных.Регистратор,
	|	НДСНоменклатурныйСоставДляНалоговыхНакладных.АналитикаУчетаПоПартнерам,
	|	НДСНоменклатурныйСоставДляНалоговыхНакладных.ОбъектРасчетов,
	|	НДСНоменклатурныйСоставДляНалоговыхНакладных.ВидПоставки,
	|	-1 КАК ЗнакРегистра
	|ПОМЕСТИТЬ ВТНДСНоменклатурныйСостав
	|ИЗ
	|	РегистрНакопления.НДСНоменклатурныйСоставДляНалоговыхНакладных КАК НДСНоменклатурныйСоставДляНалоговыхНакладных
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(НДСНоменклатурныйСоставДляНалоговыхНакладных.Регистратор) = ТИП(Документ.ВозвратТоваровОтКлиента)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТНДСНоменклатурныйСостав.Регистратор КАК Ссылка
	|ИЗ
	|	ВТНДСНоменклатурныйСостав КАК ВТНДСНоменклатурныйСостав
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНДСРасчетНО КАК ВТНДСРасчетНО
	|		ПО (ВТНДСРасчетНО.Регистратор = ВТНДСНоменклатурныйСостав.Регистратор)
	|			И (ВТНДСРасчетНО.АналитикаУчетаПоПартнерам = ВТНДСНоменклатурныйСостав.АналитикаУчетаПоПартнерам)
	|			И (ВТНДСРасчетНО.ОбъектРасчетов = ВТНДСНоменклатурныйСостав.ОбъектРасчетов)
	|			И (ВТНДСРасчетНО.ВидПоставки = ВТНДСНоменклатурныйСостав.ВидПоставки)
	|ГДЕ
	|	ЕСТЬNULL(ВТНДСРасчетНО.ЗнакРегистра, 0) + ВТНДСНоменклатурныйСостав.ЗнакРегистра <> 0";
	
	ДанныеКОбработке = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(
		Параметры,
		ДанныеКОбработке,
		ДополнительныеПараметры);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли


