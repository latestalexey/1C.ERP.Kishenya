#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура ОчиститьФильтрНачисленийВСуществующихДокументах() Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИзменениеПлановыхНачисленийНачисления.Ссылка
	|ИЗ
	|	Документ.ИзменениеПлановыхНачислений.Начисления КАК ИзменениеПлановыхНачисленийНачисления";
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Объект.Начисления.Очистить();
			Объект.ОбменДанными.Загрузка = Истина;
			Объект.Записать(РежимЗаписиДокумента.Запись);
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПеренестиДатыИзмененияИзШапкиВСотрудников() Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПлановыеНачисления.Сотрудник,
	|	МИНИМУМ(ПлановыеНачисления.Период) КАК Период,
	|	МИНИМУМ(ВЫБОР
	|			КОГДА ПлановыеНачисления.ДействуетДо = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ПлановыеНачисления.ДействуетДо
	|			ИНАЧЕ ДОБАВИТЬКДАТЕ(ПлановыеНачисления.ДействуетДо, ДЕНЬ, -1)
	|		КОНЕЦ) КАК ДействуетДо,
	|	ПлановыеНачисления.Регистратор
	|ПОМЕСТИТЬ ВТПериодыСотрудниковВДвижениях
	|ИЗ
	|	РегистрСведений.ПлановыеНачисления КАК ПлановыеНачисления
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(ПлановыеНачисления.Регистратор) = ТИП(Документ.ИзменениеПлановыхНачислений)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПлановыеНачисления.Сотрудник,
	|	ПлановыеНачисления.Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИзменениеПлановыхНачисленийСотрудники.Ссылка КАК Ссылка,
	|	ВТПериодыСотрудниковВДвижениях.Период,
	|	ВТПериодыСотрудниковВДвижениях.ДействуетДо,
	|	ВТПериодыСотрудниковВДвижениях.Сотрудник,
	|	ИзменениеПлановыхНачисленийСотрудники.НомерСтроки
	|ИЗ
	|	Документ.ИзменениеПлановыхНачислений.Сотрудники КАК ИзменениеПлановыхНачисленийСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПериодыСотрудниковВДвижениях КАК ВТПериодыСотрудниковВДвижениях
	|		ПО ИзменениеПлановыхНачисленийСотрудники.Ссылка = ВТПериодыСотрудниковВДвижениях.Регистратор
	|			И ИзменениеПлановыхНачисленийСотрудники.Сотрудник = ВТПериодыСотрудниковВДвижениях.Сотрудник
	|			И (НАЧАЛОПЕРИОДА(ИзменениеПлановыхНачисленийСотрудники.ДатаИзменения, ДЕНЬ) <> НАЧАЛОПЕРИОДА(ВТПериодыСотрудниковВДвижениях.Период, ДЕНЬ)
	|				ИЛИ НАЧАЛОПЕРИОДА(ИзменениеПлановыхНачисленийСотрудники.ДатаОкончания, ДЕНЬ) <> НАЧАЛОПЕРИОДА(ВТПериодыСотрудниковВДвижениях.ДействуетДо, ДЕНЬ))
	|ИТОГИ ПО
	|	Ссылка";
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		ВыборкаДокументов = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Отбор = Новый Структура;
		
		Пока ВыборкаДокументов.Следующий() Цикл
			
			Объект = ВыборкаДокументов.Ссылка.ПолучитьОбъект();
			ВыборкаСтрок = ВыборкаДокументов.Выбрать();
			
			Пока ВыборкаСтрок.Следующий() Цикл
				Объект.Сотрудники[ВыборкаСтрок.НомерСтроки - 1].ДатаИзменения = ВыборкаСтрок.Период;
				Объект.Сотрудники[ВыборкаСтрок.НомерСтроки - 1].ДатаОкончания = ВыборкаСтрок.ДействуетДо;
			КонецЦикла;
			Объект.ОбменДанными.Загрузка = Истина;
			Объект.Записать(РежимЗаписиДокумента.Запись);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьНезаполненныеПоказателиИПоказателиСНулевымЗначением() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ИзменениеПлановыхНачисленийПоказателиСотрудников.Ссылка,
		|	ИзменениеПлановыхНачисленийПоказателиСотрудников.Ссылка.Проведен
		|ИЗ
		|	Документ.ИзменениеПлановыхНачислений.ПоказателиСотрудников КАК ИзменениеПлановыхНачисленийПоказателиСотрудников
		|ГДЕ
		|	ИзменениеПлановыхНачисленийПоказателиСотрудников.Значение = 0";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			
			СтрокиКУдалению = Новый Массив;
			Для каждого СтрокаПоказателя Из ДокументОбъект.ПоказателиСотрудников Цикл
				
				Если Не ЗначениеЗаполнено(СтрокаПоказателя.Показатель)
					Или СтрокаПоказателя.Значение = 0 Тогда
					
					СтрокиКУдалению.Добавить(СтрокаПоказателя);
					
				КонецЕсли;
				
			КонецЦикла;
			
			Для каждого УдаляемаяСтрока Из СтрокиКУдалению Цикл
				ДокументОбъект.ПоказателиСотрудников.Удалить(УдаляемаяСтрока);
			КонецЦикла;
			
			ДокументОбъект.ОбменДанными.Загрузка = Истина;
			ДокументОбъект.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
			
			НаборЗаписей = РегистрыСведений.ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Ссылка);
			
			НаборЗаписей.Прочитать();
			
			СтрокиКУдалению = Новый Массив;
			Для каждого СтрокаДвижений Из НаборЗаписей Цикл
				
				Если СтрокаДвижений.Значение = 0
					И Не (ЗначениеЗаполнено(СтрокаДвижений.ДействуетДо) Или СтрокаДвижений.ЗначениеПоОкончании = 0) Тогда
					
					СтрокиКУдалению.Добавить(СтрокаДвижений);
					
				ИначеЕсли ЗначениеЗаполнено(СтрокаДвижений.ДействуетДо) И СтрокаДвижений.Период > СтрокаДвижений.ДействуетДо Тогда
					СтрокиКУдалению.Добавить(СтрокаДвижений);
				КонецЕсли;
				
			КонецЦикла;
			
			Если СтрокиКУдалению.Количество() > 0 Тогда
				
				Для каждого УдаляемаяСтрока Из СтрокиКУдалению Цикл
					НаборЗаписей.Удалить(УдаляемаяСтрока);
				КонецЦикла;
				
				НаборЗаписей.ОбменДанными.Загрузка = Истина;
				НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
				НаборЗаписей.Записать();
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область НачисленияПоказателиСотрудников

Функция ПараметрыПолученияНачисленийПоказателейСотрудников() Экспорт 
	
	ПараметрыПолучения = Новый Структура;
	ПараметрыПолучения.Вставить("Ссылка", Документы.ИзменениеПлановыхНачислений.ПустаяСсылка());
	ПараметрыПолучения.Вставить("ИспользоватьФильтрПоНачислениям", Ложь);
	ПараметрыПолучения.Вставить("ФильтрНачислений", Новый ТаблицаЗначений);
	ПараметрыПолучения.Вставить("ИспользоватьФильтрСотрудников", Ложь);
	ПараметрыПолучения.Вставить("ФильтрСотрудников", ПустойФильтрСотрудников());
	ПараметрыПолучения.Вставить("ЭтоОтражениеИзмененияШтатногоРасписания", Ложь);
	ПараметрыПолучения.Вставить("ИзменениеШтатногоРасписания", Документы.ИзменениеШтатногоРасписания.ПустаяСсылка());
	ПараметрыПолучения.Вставить("ИдентификаторСтрокиПозиции", 0);
	ПараметрыПолучения.Вставить("Организация", Справочники.Организации.ПустаяСсылка());
	ПараметрыПолучения.Вставить("Подразделение", Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
	ПараметрыПолучения.Вставить("ДатаИзменения", '00010101');
	ПараметрыПолучения.Вставить("ДатаОкончания", '00010101');
	ПараметрыПолучения.Вставить("ПолеДолжность", "Должность");
	ПараметрыПолучения.Вставить("Должность", Справочники.Должности.ПустаяСсылка());
	ПараметрыПолучения.Вставить("ДолжностьПоШтатномуРасписанию", Справочники.ШтатноеРасписание.ПустаяСсылка());
	
	Возврат ПараметрыПолучения;
	
КонецФункции 

Функция ПустойФильтрСотрудников() Экспорт 
	
	ФильтрСотрудников = Новый ТаблицаЗначений;
	ФильтрСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ФильтрСотрудников.Колонки.Добавить("ДатаИзменения", Новый ОписаниеТипов("Дата"));
	
	Возврат ФильтрСотрудников;
	
КонецФункции 

Функция ФильтрСотрудниковПоПараметрам(МассивСотрудников, ДатаИзменения) Экспорт 
	
	ФильтрСотрудников = ПустойФильтрСотрудников();
	Для каждого Сотрудник Из МассивСотрудников Цикл
		ЭлементФильтра = ФильтрСотрудников.Добавить();
		ЭлементФильтра.Сотрудник = Сотрудник;
		ЭлементФильтра.ДатаИзменения = ДатаИзменения;
	КонецЦикла;
	
	Возврат ФильтрСотрудников;
	
КонецФункции 

Функция НачисленияПоказателиСотрудников(ПараметрыПолучения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ДобавитьВременныеТаблицыДляПолученияНачисленийПоказателейСотрудников(Запрос.МенеджерВременныхТаблиц, ПараметрыПолучения);
	
	Сотрудники = ПолученныеСотрудники(Запрос, ПараметрыПолучения);
	
	Если ПараметрыПолучения.ЭтоОтражениеИзмененияШтатногоРасписания Тогда
		НачисленияСотрудников = ИзмененныеНачисленияСотрудниковНаПозиции(Запрос);
		ПоказателиСотрудников = ИзмененныеПоказателиСотрудниковНаПозиции(Запрос);
	Иначе
		НачисленияСотрудников = НачисленияСотрудников(Запрос);
		ПоказателиСотрудников = ПоказателиСотрудников(Запрос);
	КонецЕсли;
	
	Возврат Новый Структура("Сотрудники,НачисленияСотрудников,ПоказателиСотрудников", Сотрудники, НачисленияСотрудников, ПоказателиСотрудников);
	
КонецФункции

Функция ПолученныеСотрудники(Запрос, ПараметрыПолучения)
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТСотрудники.Сотрудник,
	|	ВТСотрудники.Период КАК ДатаИзменения
	|ИЗ
	|	ВТСотрудникиПериоды КАК ВТСотрудники";
	
	ЗарплатаКадры.ДополнитьТекстЗапросаУпорядочиваниемСотрудниковПоВТСДаннымиПорядка(Запрос, "ВТСотрудники");
	
	ПолученныеСотрудники = Запрос.Выполнить().Выгрузить();
	
	ПолученныеСотрудники.Колонки.Добавить("ДатаОкончания", Новый ОписаниеТипов("Дата"));
	ПолученныеСотрудники.ЗаполнитьЗначения(ПараметрыПолучения.ДатаОкончания, "ДатаОкончания");
	
	Возврат ПолученныеСотрудники;

КонецФункции

Функция ИзмененныеНачисленияСотрудниковНаПозиции(Запрос)
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НачисленияПозицииИСотрудников.Сотрудник КАК Сотрудник,
	|	НачисленияПозицииИСотрудников.Начисление КАК Начисление,
	|	НачисленияПозицииИСотрудников.ДокументОснование КАК ДокументОснование,
	|	СУММА(НачисленияПозицииИСотрудников.Размер) КАК Размер,
	|	НачисленияПозицииИСотрудников.Действие КАК Действие
	|ИЗ
	|	ВТНачисленияПозицииИСотрудников КАК НачисленияПозицииИСотрудников
	|
	|СГРУППИРОВАТЬ ПО
	|	НачисленияПозицииИСотрудников.Сотрудник,
	|	НачисленияПозицииИСотрудников.Начисление,
	|	НачисленияПозицииИСотрудников.ДокументОснование,
	|	НачисленияПозицииИСотрудников.Действие";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции 

Функция ИзмененныеПоказателиСотрудниковНаПозиции(Запрос)
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НачисленияПозицииИСотрудников.Сотрудник КАК Сотрудник,
	|	ЕСТЬNULL(ПоказателиНачислений.Показатель, ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)) КАК Показатель,
	|	НачисленияПозицииИСотрудников.ДокументОснование КАК ДокументОснование,
	|	ЕСТЬNULL(ЗначенияПоказателейСотрудников.Значение, 0) КАК Значение
	|ПОМЕСТИТЬ ВТПоказателиПоСотрудникам
	|ИЗ
	|	ВТНачисленияПозицииИСотрудников КАК НачисленияПозицииИСотрудников
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.Начисления.Показатели КАК ПоказателиНачислений
	|		ПО НачисленияПозицииИСотрудников.Начисление = ПоказателиНачислений.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗначенияПоказателейСотрудников КАК ЗначенияПоказателейСотрудников
	|		ПО (ЗначенияПоказателейСотрудников.Показатель = ПоказателиНачислений.Показатель)
	|			И (ЗначенияПоказателейСотрудников.Сотрудник = НачисленияПозицииИСотрудников.Сотрудник)
	|			И (ЗначенияПоказателейСотрудников.ДокументОснование = НачисленияПозицииИСотрудников.ДокументОснование)
	|ГДЕ
	|	ВЫБОР
	|			КОГДА НачисленияПозицииИСотрудников.Действие ЕСТЬ NULL 
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ НачисленияПозицииИСотрудников.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
	|		КОНЕЦ
	|	И ПоказателиНачислений.ЗапрашиватьПриВводе
	|
	|СГРУППИРОВАТЬ ПО
	|	НачисленияПозицииИСотрудников.Сотрудник,
	|	ЕСТЬNULL(ПоказателиНачислений.Показатель, ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)),
	|	НачисленияПозицииИСотрудников.ДокументОснование,
	|	ЕСТЬNULL(ЗначенияПоказателейСотрудников.Значение, 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоказателиПоСотрудникам.Сотрудник КАК Сотрудник,
	|	ПоказателиПоСотрудникам.Показатель КАК Показатель,
	|	ПоказателиПоСотрудникам.ДокументОснование КАК ДокументОснование,
	|	ВЫБОР
	|		КОГДА ПоказателиПоПозиции.Показатель ЕСТЬ NULL 
	|			ТОГДА ПоказателиПоСотрудникам.Значение
	|		КОГДА ПоказателиПоСотрудникам.Значение >= ПоказателиПоПозиции.ЗначениеПоказателяМин
	|					И ПоказателиПоСотрудникам.Значение <= ПоказателиПоПозиции.ЗначениеПоказателяМакс
	|				ИЛИ ПоказателиПоПозиции.ЗначениеПоказателяМин = НЕОПРЕДЕЛЕНО
	|					И ПоказателиПоПозиции.ЗначениеПоказателяМакс = НЕОПРЕДЕЛЕНО
	|			ТОГДА ПоказателиПоСотрудникам.Значение
	|		КОГДА ПоказателиПоСотрудникам.Значение <= ПоказателиПоПозиции.ЗначениеПоказателяМин
	|			ТОГДА ПоказателиПоПозиции.ЗначениеПоказателяМин
	|		ИНАЧЕ ПоказателиПоПозиции.ЗначениеПоказателяМакс
	|	КОНЕЦ КАК Значение
	|ИЗ
	|	ВТПоказателиПоСотрудникам КАК ПоказателиПоСотрудникам
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТекущиеПоказателиПозиции КАК ПоказателиПоПозиции
	|		ПО ПоказателиПоСотрудникам.Показатель = ПоказателиПоПозиции.Показатель
	|			И ПоказателиПоСотрудникам.ДокументОснование = ПоказателиПоПозиции.ДокументОснование
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоказателиПоСотрудникам.Сотрудник,
	|	ПоказателиПоСотрудникам.Показатель,
	|	ПоказателиПоСотрудникам.ДокументОснование,
	|	ВЫБОР
	|		КОГДА ПоказателиПоПозиции.Показатель ЕСТЬ NULL 
	|			ТОГДА ПоказателиПоСотрудникам.Значение
	|		КОГДА ПоказателиПоСотрудникам.Значение >= ПоказателиПоПозиции.ЗначениеПоказателяМин
	|					И ПоказателиПоСотрудникам.Значение <= ПоказателиПоПозиции.ЗначениеПоказателяМакс
	|				ИЛИ ПоказателиПоПозиции.ЗначениеПоказателяМин = НЕОПРЕДЕЛЕНО
	|					И ПоказателиПоПозиции.ЗначениеПоказателяМакс = НЕОПРЕДЕЛЕНО
	|			ТОГДА ПоказателиПоСотрудникам.Значение
	|		КОГДА ПоказателиПоСотрудникам.Значение <= ПоказателиПоПозиции.ЗначениеПоказателяМин
	|			ТОГДА ПоказателиПоПозиции.ЗначениеПоказателяМин
	|		ИНАЧЕ ПоказателиПоПозиции.ЗначениеПоказателяМакс
	|	КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции 

Функция НачисленияСотрудников(Запрос)
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВТНачисленияСотрудников.Сотрудник,
	|	ВТНачисленияСотрудников.Начисление,
	|	ВТНачисленияСотрудников.ДокументОснование,
	|	ВТНачисленияСотрудников.Размер,
	|	ВТНачисленияСотрудников.Действие
	|ИЗ
	|	ВТНачисленияСотрудников КАК ВТНачисленияСотрудников";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПоказателиСотрудников(Запрос)
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПлановыеНачисленияСотрудников.Сотрудник КАК Сотрудник,
	|	ПоказателиНачислений.Показатель КАК Показатель,
	|	ПлановыеНачисленияСотрудников.ДокументОснование КАК ДокументОснование,
	|	ЕСТЬNULL(ЗначенияПоказателейСотрудников.Значение, 0) КАК Значение
	|ИЗ
	|	ВТНачисленияСотрудников КАК ПлановыеНачисленияСотрудников
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовРасчета.Начисления.Показатели КАК ПоказателиНачислений
	|		ПО ПлановыеНачисленияСотрудников.Начисление = ПоказателиНачислений.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗначенияПоказателейСотрудников КАК ЗначенияПоказателейСотрудников
	|		ПО (ЗначенияПоказателейСотрудников.Показатель = ПоказателиНачислений.Показатель)
	|			И (ЗначенияПоказателейСотрудников.Сотрудник = ПлановыеНачисленияСотрудников.Сотрудник)
	|			И (ЗначенияПоказателейСотрудников.ДокументОснование = ПлановыеНачисленияСотрудников.ДокументОснование)
	|ГДЕ
	|	ПоказателиНачислений.ЗапрашиватьПриВводе";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#Область ВременныеТаблицыДляПолученияНачисленийПоказателейСотрудников

Процедура ДобавитьВременныеТаблицыДляПолученияНачисленийПоказателейСотрудников(МенеджерВременныхТаблиц, ПараметрыПолучения)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Если ПараметрыПолучения.ИспользоватьФильтрСотрудников Тогда
		СоздатьВТСотрудникиПериодыПоСотруднику(Запрос, ПараметрыПолучения);	
	Иначе
		СоздатьВТСотрудникиПериоды(Запрос, ПараметрыПолучения);
	КонецЕсли;
	
	ОписаниеФильтра = ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТСотрудникиПериоды", "Период,Сотрудник");
	
	СоздатьВТПлановыеНачисленияСотрудников(Запрос, ОписаниеФильтра, ПараметрыПолучения);
	СоздатьВТНачисленияСотрудников(Запрос, ПараметрыПолучения);
	СоздатьВТЗначенияПоказателейСотрудников(Запрос, ОписаниеФильтра, ПараметрыПолучения);
	
	Если ПараметрыПолучения.ЭтоОтражениеИзмененияШтатногоРасписания Тогда
		ПодготовитьВременныеТаблицыПоПозиции(Запрос, ПараметрыПолучения);
		СоздатьВТНачисленияПозицииИСотрудников(Запрос);
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьВТСотрудникиПериоды(Запрос, ПараметрыПолучения)
	
	КадровыеДанные = ПараметрыПолучения.ПолеДолжность;
	ЗарплатаКадры.ДополнитьКадровымиДаннымиНастройкиПорядкаСписка(КадровыеДанные);
	
	Параметры = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	Параметры.Организация 		= ПараметрыПолучения.Организация;
	Параметры.Подразделение 	= ПараметрыПолучения.Подразделение;
	Параметры.НачалоПериода 	= ПараметрыПолучения.ДатаИзменения;
	Параметры.ОкончаниеПериода 	= ПараметрыПолучения.ДатаИзменения;
	Параметры.КадровыеДанные 	= КадровыеДанные;
	
	Если ЗначениеЗаполнено(ПараметрыПолучения[ПараметрыПолучения.ПолеДолжность]) Тогда
		ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(Параметры.Отборы, ПараметрыПолучения.ПолеДолжность, "=", ПараметрыПолучения[ПараметрыПолучения.ПолеДолжность]);
	КонецЕсли;
	
	КадровыйУчетРасширенный.ПрименитьОтборПоФункциональнойОпцииВыполнятьРасчетЗарплатыПоПодразделениям(Параметры);
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, Параметры);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Сотрудники.*
	|ПОМЕСТИТЬ ВТСотрудникиПериоды
	|ИЗ
	|	ВТСотрудникиОрганизации КАК Сотрудники";
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.Выполнить()
	
КонецПроцедуры

Процедура СоздатьВТСотрудникиПериодыПоСотруднику(Запрос, ПараметрыПолучения)
	
	ТЗСотрудников = Новый ТаблицаЗначений;
	ТЗСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТЗСотрудников.Колонки.Добавить("Период", 	ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.ДатаВремя));
	
	Для каждого ЭлементФильтра Из ПараметрыПолучения.ФильтрСотрудников Цикл
		НоваяСтрока = ТЗСотрудников.Добавить();
		НоваяСтрока.Сотрудник 	= ЭлементФильтра.Сотрудник;
		НоваяСтрока.Период 		= ЭлементФильтра.ДатаИзменения;
	КонецЦикла;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТЗСотрудников.Период КАК Период,
	|	ТЗСотрудников.Сотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	&ТЗСотрудников КАК ТЗСотрудников";
	
	Запрос.УстановитьПараметр("ТЗСотрудников", ТЗСотрудников);
	Запрос.Текст = ТекстЗапроса;
	Запрос.Выполнить();
	
	ОписательТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц,
		"ВТСотрудники");
		
	ОписательТаблиц.ИмяВТКадровыеДанныеСотрудников = "ВТСотрудникиПериоды";
	
	КадровыеДанные = ПараметрыПолучения.ПолеДолжность;
	ЗарплатаКадры.ДополнитьКадровымиДаннымиНастройкиПорядкаСписка(КадровыеДанные);
	
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательТаблиц, Истина, КадровыеДанные, , Ложь);
	
КонецПроцедуры

Процедура СоздатьВТПлановыеНачисленияСотрудников(Запрос, ОписаниеФильтра, ПараметрыПолучения)
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
	ПараметрыПостроения.ФормироватьСПериодичностьДень = Ложь;
	ПараметрыПостроенияФОТ = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
	ПараметрыПостроенияФОТ.ФормироватьСПериодичностьДень = Ложь;
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПостроения.Отборы, "Регистратор", "<>", ПараметрыПолучения.Ссылка);
	
	Если НЕ ПараметрыПолучения.ЭтоОтражениеИзмененияШтатногоРасписания 
		И ПараметрыПолучения.ИспользоватьФильтрПоНачислениям Тогда
		
		ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПостроения.Отборы, "Начисление", "В", ПараметрыПолучения.ФильтрНачислений.ВыгрузитьКолонку("Начисление"));
		ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПостроенияФОТ.Отборы, "Начисление", "В", ПараметрыПолучения.ФильтрНачислений.ВыгрузитьКолонку("Начисление"));
	
	КонецЕсли;

	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ПлановыеНачисления",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ОписаниеФильтра,
		ПараметрыПостроения);
		
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ПлановыйФОТ",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ОписаниеФильтра,
		ПараметрыПостроенияФОТ);
		
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПлановыеНачисления.Период,
	|	ПлановыеНачисления.Сотрудник,
	|	ПлановыеНачисления.Начисление,
	|	ПлановыеНачисления.ДокументОснование,
	|	ВЫБОР
	|		КОГДА ПлановыйФОТ.ВкладВФОТ ЕСТЬ NULL 
	|			ТОГДА ПлановыеНачисления.Размер
	|		ИНАЧЕ ПлановыйФОТ.ВкладВФОТ
	|	КОНЕЦ КАК Размер
	|ПОМЕСТИТЬ ВТПлановыеНачисленияСотрудников
	|ИЗ
	|	ВТПлановыеНачисленияСрезПоследних КАК ПлановыеНачисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПлановыйФОТСрезПоследних КАК ПлановыйФОТ
	|		ПО ПлановыеНачисления.Сотрудник = ПлановыйФОТ.Сотрудник
	|			И ПлановыеНачисления.Начисление = ПлановыйФОТ.Начисление
	|			И ПлановыеНачисления.ДокументОснование = ПлановыйФОТ.ДокументОснование
	|ГДЕ
	|	НЕ ВЫРАЗИТЬ(ПлановыеНачисления.Начисление КАК ПланВидовРасчета.Начисления).КатегорияНачисленияИлиНеоплаченногоВремени В (&ИсключаемыеКатегории)
	|	И НЕ ВЫРАЗИТЬ(ПлановыеНачисления.Начисление КАК ПланВидовРасчета.Начисления).ЯвляетсяЛьготой
	|	И ПлановыеНачисления.Используется";
	
	ИсключаемыеКатегории = Новый СписокЗначений;
	ИсключаемыеКатегории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПособиеПоУходуЗаРебенкомДоПолутораЛет);
	ИсключаемыеКатегории.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПособиеПоУходуЗаРебенкомДоТрехЛет);
	
	Запрос.УстановитьПараметр("ИсключаемыеКатегории", ИсключаемыеКатегории);
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура СоздатьВТНачисленияСотрудников(Запрос, ПараметрыПолучения)
	
	Если ПараметрыПолучения.ИспользоватьФильтрПоНачислениям Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Начисления.Действие,
		|	Начисления.Начисление
		|ПОМЕСТИТЬ ВТФильтрНачислений
		|ИЗ
		|	&Начисления КАК Начисления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТСотрудникиПериоды.Сотрудник,
		|	0 КАК Размер,
		|	ВТФильтрНачислений.Действие,
		|	ВТФильтрНачислений.Начисление
		|ПОМЕСТИТЬ ВТФильтрНачисленийСотрудников
		|ИЗ
		|	ВТСотрудникиПериоды КАК ВТСотрудникиПериоды
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФильтрНачислений КАК ВТФильтрНачислений
		|		ПО (ИСТИНА)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТФильтрНачисленийСотрудников.Сотрудник,
		|	ВТФильтрНачисленийСотрудников.Начисление,
		|	ЕСТЬNULL(ПлановыеНачисления.ДокументОснование, НЕОПРЕДЕЛЕНО) КАК ДокументОснование,
		|	ЕСТЬNULL(ПлановыеНачисления.Размер, ВТФильтрНачисленийСотрудников.Размер) КАК Размер,
		|	ВТФильтрНачисленийСотрудников.Действие КАК Действие
		|ПОМЕСТИТЬ ВТНачисленияСотрудников
		|ИЗ
		|	ВТФильтрНачисленийСотрудников КАК ВТФильтрНачисленийСотрудников
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПлановыеНачисленияСотрудников КАК ПлановыеНачисления
		|		ПО ВТФильтрНачисленийСотрудников.Сотрудник = ПлановыеНачисления.Сотрудник
		|			И ВТФильтрНачисленийСотрудников.Начисление = ПлановыеНачисления.Начисление
		|ГДЕ
		|	(ВТФильтрНачисленийСотрудников.Действие = &ДействиеНачать
		|			ИЛИ НЕ ПлановыеНачисления.Начисление ЕСТЬ NULL )";
		
		Запрос.УстановитьПараметр("Начисления", ПараметрыПолучения.ФильтрНачислений);
		Запрос.УстановитьПараметр("ДействиеНачать", Перечисления.ДействияСНачислениямиИУдержаниями.Утвердить);
		
	Иначе
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПлановыеНачисления.Сотрудник,
		|	ПлановыеНачисления.Начисление,
		|	ПлановыеНачисления.ДокументОснование,
		|	ПлановыеНачисления.Размер,
		|	ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.ПустаяСсылка) КАК Действие
		|ПОМЕСТИТЬ ВТНачисленияСотрудников
		|ИЗ
		|	ВТПлановыеНачисленияСотрудников КАК ПлановыеНачисления";
		
	КонецЕсли;
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура СоздатьВТЗначенияПоказателейСотрудников(Запрос, ОписаниеФильтра, ПараметрыПолучения)
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
	ПараметрыПостроения.ФормироватьСПериодичностьДень = Ложь;
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПостроения.Отборы, "Регистратор", "<>", ПараметрыПолучения.Ссылка);
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПостроения.Отборы, "Организация", "=", ПараметрыПолучения.Организация);
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ОписаниеФильтра,
		ПараметрыПостроения,
		"ВТЗначенияПоказателейСотрудников");
	
КонецПроцедуры

Процедура ПодготовитьВременныеТаблицыПоПозиции(Запрос, ПараметрыПолучения)
	ДанныеПозиции = УправлениеШтатнымРасписанием.ДанныеПозицииШтатногоРасписания(ПараметрыПолучения.ДолжностьПоШтатномуРасписанию, ПараметрыПолучения.ДатаИзменения);
	СоздатьВТИзмененияНачисленийПозиции(Запрос, ДанныеПозиции, ПараметрыПолучения);	
	СоздатьВТТекущиеПоказателиПозиции(Запрос, ДанныеПозиции);
КонецПроцедуры

Процедура СоздатьВТИзмененияНачисленийПозиции(Запрос, ДанныеПозиции, ПараметрыПолучения)
	
	ПредыдущиеНачисления = ПредыдущиеНачисленияПозиции(ПараметрыПолучения);
	
	ТаблицаНачислений  = Новый ТаблицаЗначений;
	ТаблицаНачислений.Колонки.Добавить("Начисление", Новый ОписаниеТипов("ПланВидовРасчетаСсылка.Начисления"));
	ТаблицаНачислений.Колонки.Добавить("ДокументОснование", Метаданные.ОпределяемыеТипы.ОснованиеНачисления.Тип);
	ТаблицаНачислений.Колонки.Добавить("Действие", Новый ОписаниеТипов("ПеречислениеСсылка.ДействияСНачислениямиИУдержаниями"));
	
	Для каждого Начисление Из ДанныеПозиции.Начисления Цикл
		НоваяСтрокаНачислений = ТаблицаНачислений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаНачислений, Начисление);
		
		СтруктураПоиска = Новый Структура("Начисление", Начисление.Начисление);
		СтрокиПредыдущихНачислений = ПредыдущиеНачисления.НайтиСтроки(СтруктураПоиска);
		Если СтрокиПредыдущихНачислений.Количество() = 0 Тогда
			НоваяСтрокаНачислений.Действие = Перечисления.ДействияСНачислениямиИУдержаниями.Утвердить;
		Иначе
			Для каждого СтрокаПредыдущихНачислений Из СтрокиПредыдущихНачислений Цикл
				ПредыдущиеНачисления.Удалить(СтрокаПредыдущихНачислений);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого СтрокаПредыдущегоНачисления Из ПредыдущиеНачисления Цикл
		
		НоваяСтрокаНачислений = ТаблицаНачислений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаНачислений, СтрокаПредыдущегоНачисления);
		НоваяСтрокаНачислений.Действие = Перечисления.ДействияСНачислениямиИУдержаниями.Отменить;
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("Начисления", ТаблицаНачислений);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Начисления.Начисление,
	|	Начисления.ДокументОснование,
	|	Начисления.Действие
	|ПОМЕСТИТЬ ВТИзмененияНачисленийПозиции
	|ИЗ
	|	&Начисления КАК Начисления";
	
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ПредыдущиеНачисленияПозиции(ПараметрыПолучения)
	
	ПредыдущиеДанныеПозиции = УправлениеШтатнымРасписанием.ДанныеПозицииШтатногоРасписания(ПараметрыПолучения.ДолжностьПоШтатномуРасписанию, НачалоДня(ПараметрыПолучения.ДатаИзменения) - 1);
	
	ПредыдущиеНачисления = Новый ТаблицаЗначений;
	ПредыдущиеНачисления.Колонки.Добавить("Начисление", Новый ОписаниеТипов("ПланВидовРасчетаСсылка.Начисления"));
	
	Для каждого ОписаниеНачисления Из ПредыдущиеДанныеПозиции.Начисления Цикл
		ЗаполнитьЗначенияСвойств(ПредыдущиеНачисления.Добавить(), ОписаниеНачисления);
	КонецЦикла;
	
	Возврат ПредыдущиеНачисления;
	
КонецФункции 

Процедура СоздатьВТТекущиеПоказателиПозиции(Запрос, ДанныеПозиции)
	
	ТаблицаПоказателей  = Новый ТаблицаЗначений;
	ТаблицаПоказателей.Колонки.Добавить("Показатель", Новый ОписаниеТипов("СправочникСсылка.ПоказателиРасчетаЗарплаты"));
	ТаблицаПоказателей.Колонки.Добавить("ДокументОснование", Метаданные.ОпределяемыеТипы.ОснованиеНачисления.Тип);
	ТаблицаПоказателей.Колонки.Добавить("ЗначениеМин", Новый ОписаниеТипов("Число"));
	ТаблицаПоказателей.Колонки.Добавить("ЗначениеМакс", Новый ОписаниеТипов("Число"));
	
	Для каждого Начисление Из ДанныеПозиции.Начисления Цикл
		Для каждого ПоказательНачисления Из Начисление.Показатели Цикл
			ЗаполнитьЗначенияСвойств(ТаблицаПоказателей.Добавить(), ПоказательНачисления);
		КонецЦикла;
	КонецЦикла;
	
	ТаблицаПоказателей.Колонки["ЗначениеМин"].Имя 	= "ЗначениеПоказателяМин";
	ТаблицаПоказателей.Колонки["ЗначениеМакс"].Имя 	= "ЗначениеПоказателяМакс";
	
	Запрос.УстановитьПараметр("ТаблицаПоказателей", 	ТаблицаПоказателей);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаПоказателей.Показатель,
	|	ТаблицаПоказателей.ДокументОснование,
	|	ТаблицаПоказателей.ЗначениеПоказателяМин,
	|	ТаблицаПоказателей.ЗначениеПоказателяМакс
	|ПОМЕСТИТЬ ВТТекущиеПоказателиПозиции
	|ИЗ
	|	&ТаблицаПоказателей КАК ТаблицаПоказателей";
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура СоздатьВТНачисленияПозицииИСотрудников(Запрос)
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СотрудникиПоПозиции.Сотрудник,
	|	НачисленияПоПозиции.Начисление,
	|	НачисленияПоПозиции.ДокументОснование КАК ДокументОснование,
	|	НачисленияПоПозиции.Действие КАК Действие
	|ПОМЕСТИТЬ ВТНачисленияСотрудниковНаПозиции
	|ИЗ
	|	ВТСотрудникиПериоды КАК СотрудникиПоПозиции
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТИзмененияНачисленийПозиции КАК НачисленияПоПозиции
	|		ПО (ИСТИНА)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(НачисленияСотрудниковПозиции.Сотрудник, ПлановыеНачисления.Сотрудник) КАК Сотрудник,
	|	ЕСТЬNULL(НачисленияСотрудниковПозиции.Начисление, ПлановыеНачисления.Начисление) КАК Начисление,
	|	ЕСТЬNULL(НачисленияСотрудниковПозиции.ДокументОснование, ПлановыеНачисления.ДокументОснование) КАК ДокументОснование,
	|	ЕСТЬNULL(ПлановыеНачисления.Размер, 0) КАК Размер,
	|	ЕСТЬNULL(НачисленияСотрудниковПозиции.Действие, ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.ПустаяСсылка)) КАК Действие
	|ПОМЕСТИТЬ ВТНачисленияПозицииИСотрудников
	|ИЗ
	|	ВТНачисленияСотрудниковНаПозиции КАК НачисленияСотрудниковПозиции
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТПлановыеНачисленияСотрудников КАК ПлановыеНачисления
	|		ПО НачисленияСотрудниковПозиции.Сотрудник = ПлановыеНачисления.Сотрудник
	|			И НачисленияСотрудниковПозиции.Начисление = ПлановыеНачисления.Начисление
	|			И НачисленияСотрудниковПозиции.ДокументОснование = ПлановыеНачисления.ДокументОснование";
	
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

Функция НачисленияПоказателиСотрудниковПоОбъекту(ДокументОбъект, ФильтрСотрудников = Неопределено) Экспорт
	
	ПараметрыПолучения = ПараметрыПолученияНачисленийПоказателейСотрудников();
	ПараметрыПолучения.Вставить("Ссылка", ДокументОбъект.Ссылка);
	ПараметрыПолучения.Вставить("Организация", ДокументОбъект.Организация);
	ПараметрыПолучения.Вставить("Подразделение", ДокументОбъект.Подразделение);
	ПараметрыПолучения.Вставить("ДатаИзменения", ЗарплатаКадрыРасширенный.ВремяРегистрацииДокумента(ДокументОбъект.Ссылка, ДокументОбъект.ДатаИзменения));
	ПараметрыПолучения.Вставить("ДатаОкончания", ДокументОбъект.ДатаОкончания);
	
	Если НЕ ДокументОбъект.ЭтоОтражениеИзмененияШтатногоРасписания 
		И ДокументОбъект.Начисления.Количество() > 0 Тогда
		
		ПараметрыПолучения.Вставить("ИспользоватьФильтрПоНачислениям", Истина);
		ПараметрыПолучения.Вставить("ФильтрНачислений", ДокументОбъект.Начисления.Выгрузить());
		
		СтрокиСПустымиНачислениями = ПараметрыПолучения.ФильтрНачислений.НайтиСтроки(Новый Структура("Начисление", ПланыВидовРасчета.Начисления.ПустаяСсылка()));
		Для каждого СтрокаСПустымиНачислениями Из СтрокиСПустымиНачислениями Цикл
			ПараметрыПолучения.ФильтрНачислений.Удалить(СтрокаСПустымиНачислениями);
		КонецЦикла;
		
	КонецЕсли;
	
	Если НЕ ФильтрСотрудников = Неопределено Тогда
		ПараметрыПолучения.Вставить("ИспользоватьФильтрСотрудников", Истина);
		ПараметрыПолучения.Вставить("ФильтрСотрудников", ФильтрСотрудников);
	КонецЕсли;
	
	Если ДокументОбъект.ЭтоОтражениеИзмененияШтатногоРасписания Тогда
		ПараметрыПолучения.Вставить("ЭтоОтражениеИзмененияШтатногоРасписания", Истина);
		ПараметрыПолучения.Вставить("ИзменениеШтатногоРасписания", ДокументОбъект.ИзменениеШтатногоРасписания);
		ПараметрыПолучения.Вставить("ИдентификаторСтрокиПозиции", ДокументОбъект.ИдентификаторСтрокиПозиции);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") 
		Или ДокументОбъект.ЭтоОтражениеИзмененияШтатногоРасписания Тогда
		ПараметрыПолучения.Вставить("ПолеДолжность", "ДолжностьПоШтатномуРасписанию");
		ПараметрыПолучения.Вставить("ДолжностьПоШтатномуРасписанию", ДокументОбъект.ДолжностьПоШтатномуРасписанию);
	Иначе
		ПараметрыПолучения.Вставить("ПолеДолжность", "Должность");
		ПараметрыПолучения.Вставить("Должность", ДокументОбъект.Должность);
	КонецЕсли;
	
	Возврат НачисленияПоказателиСотрудников(ПараметрыПолучения);
	
КонецФункции

Процедура ЗаполнитьСотрудников(ДокументОбъект, ТаблицаСотрудников) Экспорт
	
	Для каждого СтрокаДобавляемогоСотрудника Из ТаблицаСотрудников Цикл
		
		СтрокиДокумента = ДокументОбъект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", СтрокаДобавляемогоСотрудника.Сотрудник));
		Если СтрокиДокумента.Количество() = 0 Тогда
			СтрокаСотрудника = ДокументОбъект.Сотрудники.Добавить();
		Иначе
			СтрокаСотрудника = СтрокиДокумента[0];
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтрокаСотрудника, СтрокаДобавляемогоСотрудника);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьНачисленияПоказатели(ДокументОбъект, ТаблицаНачислений, ТаблицаПоказателей) Экспорт
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТаблицаНачислений, ДокументОбъект.НачисленияСотрудников);
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТаблицаПоказателей, ДокументОбъект.ПоказателиСотрудников);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли