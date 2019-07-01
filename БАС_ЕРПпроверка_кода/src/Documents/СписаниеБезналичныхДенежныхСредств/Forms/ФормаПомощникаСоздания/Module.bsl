
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	//++ НЕ УТ
	
	Если Параметры.Свойство("Основание") Тогда
		Если ЗначениеЗаполнено(Параметры.Основание)Тогда
			
			Если ТипЗнч(Параметры.Основание) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств") Тогда
				
				ДокументОснование   = Параметры.Основание;
				
				Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, "Валюта, Организация, БанковскийСчет");
				
				ВалютаОснование     = Реквизиты.Валюта;
				
				БанковскийСчет      = Реквизиты.БанковскийСчет;
				
				Если Не ЗначениеЗаполнено(БанковскийСчет) Тогда
					БанковскийСчет = Справочники.БанковскиеСчетаОрганизаций.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(
						Реквизиты.Организация,
						Реквизиты.Валюта);
				КонецЕсли;
				
				ИспользоватьНачислениеЗарплаты = Константы.ИспользоватьНачислениеЗарплаты.Получить();
				Если ИспользоватьНачислениеЗарплаты Тогда
					ЗаполнитьТаблицуДокументовПоВедомостямИзЗаявки()
				Иначе
					ЗаполнитьТаблицуДокументовПоФизЛицам()
				КонецЕсли;
				
			ИначеЕсли ТипЗнч(Параметры.Основание) = Тип("ДокументСсылка.ВедомостьНаВыплатуЗарплатыПеречислением") Тогда
				
				ДокументОснование           = Параметры.Основание;
				ОрганизацияДляЗаполнения    = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, "Организация").Организация;
				ВалютаДляЗаполнения         = Константы.ВалютаРегламентированногоУчета.Получить();
				ВалютаОснование             = Константы.ВалютаРегламентированногоУчета.Получить();
				БанковскийСчет              = Справочники.БанковскиеСчетаОрганизаций.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(
					ОрганизацияДляЗаполнения,
					ВалютаДляЗаполнения);
				ЗаполнитьТаблицуДокументовПоВедомости(ДокументОснование);
				
			Иначе // возможна передача массива элементов типа "ВедомостьНаВыплатуЗарплатыПеречислением"
				
				ВалютаОснование = Константы.ВалютаРегламентированногоУчета.Получить();
				ЗаполнитьТаблицуДокументовПоВедомости(Параметры.Основание.МассивВедомостей);
				
			КонецЕсли; 
			
		КонецЕсли;
	КонецЕсли;
	
	//-- НЕ УТ
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для каждого СтрокаТаблицы Из ТаблицаДокументов Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДокументСписание) Тогда
			СтрокаТаблицы.Отметка	= Истина
		КонецЕсли;
	КонецЦикла; 
	Элементы.ТаблицаДокументовСумма.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	НСтр("ru='Сумма (%1)';uk='Сума (%1)'"),
	Строка(ВалютаОснование));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицадокументов

&НаКлиенте
Процедура ТаблицаДокументовОтметкаПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Элемент.Родитель.ТекущиеДанные.ДокументСписание) Тогда
		Элемент.Родитель.ТекущиеДанные.Отметка = Ложь
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовДокументСписаниеПриИзменении(Элемент)
	Элемент.Родитель.ТекущиеДанные.Отметка = Ложь
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьФлажкиСтрок(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьФлажкиСтрок(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументы(Команда)

	Если НЕ ЗначениеЗаполнено(БанковскийСчет) Тогда
		
		СообщениеОбОшибке = НСтр("ru='Поле ""Банковский счет"" не заполнено.';uk='Поле ""Банківський рахунок"" не заповнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
		Возврат;
		
	КонецЕсли;
	
	ИндексСтроки = 0;
	Для каждого СтрокаТаблицы Из ТаблицаДокументов Цикл
		
		Если НЕ СтрокаТаблицы.Отметка Тогда
			ИндексСтроки = ИндексСтроки+1;
		    Продолжить
		КонецЕсли; 
		
		СоздатьДокументыСписаниеНаСервере(СтрокаТаблицы.ФизическоеЛицо,
										  СтрокаТаблицы.ЛицевойСчет, 
										  СтрокаТаблицы.Сумма, 
										  СтрокаТаблицы.ВедомостьПоВыплатеЗП, 
										  ИндексСтроки);
		ИндексСтроки = ИндексСтроки+1;

	КонецЦикла; 	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналДокументов(Команда)
	
	ПараметрыОтбора = Новый Структура("ДокументОснование", ДокументОснование); 
	ОткрытьФорму("Документ.СписаниеБезналичныхДенежныхСредств.ФормаСписка", ПараметрыОтбора, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьФлажкиСтрок(СоздаватьДокументы)
	
	Для Каждого СтрокаТаблицы Из ТаблицаДокументов Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДокументСписание) Тогда
		    СтрокаТаблицы.Отметка = СоздаватьДокументы;
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

//++ НЕ УТ
&НаСервере 
Процедура ЗаполнитьТаблицуДокументовПоВедомостямИзЗаявки()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Ведомости.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Ведомости.БанковскийСчет КАК ЛицевойСчет,
	|	СУММА(Ведомости.КВыплате) КАК Сумма,
	|	Ведомости.Ссылка КАК ВедомостьПоВыплатеЗП,
	|	ЕСТЬNULL(ВедомостиСписания.Ссылка, ЗНАЧЕНИЕ(Документ.СписаниеБезналичныхДенежныхСредств.ПустаяСсылка)) КАК ДокументСписание
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств.ВедомостиНаВыплатуЗарплаты КАК ВедомостиЗаявки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВедомостьНаВыплатуЗарплатыПеречислением.Зарплата КАК Ведомости
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.СписаниеБезналичныхДенежныхСредств.ВедомостиНаВыплатуЗарплаты КАК ВедомостиСписания
	|			ПО Ведомости.Сотрудник.ФизическоеЛицо = ВедомостиСписания.Ссылка.ПодотчетноеЛицо
	|				И Ведомости.БанковскийСчет = ВедомостиСписания.Ссылка.БанковскийСчетКонтрагента
	|				И Ведомости.Ссылка = ВедомостиСписания.Ведомость
	|				И НЕ ВедомостиСписания.Ссылка.ПометкаУдаления
	|		ПО ВедомостиЗаявки.Ведомость = Ведомости.Ссылка
	|ГДЕ
	|	ВедомостиЗаявки.Ссылка = &Заявка
	|
	|СГРУППИРОВАТЬ ПО
	|	Ведомости.Сотрудник.ФизическоеЛицо,
	|	Ведомости.БанковскийСчет,
	|	Ведомости.Ссылка,
	|	ЕСТЬNULL(ВедомостиСписания.Ссылка, ЗНАЧЕНИЕ(Документ.СписаниеБезналичныхДенежныхСредств.ПустаяСсылка))";
	
	Запрос.УстановитьПараметр("Заявка", ДокументОснование);
	
	ТаблицаДокументов.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуДокументовПоВедомости(Основание)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Ведомости.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Ведомости.БанковскийСчет КАК ЛицевойСчет,
	|	СУММА(Ведомости.КВыплате) КАК Сумма,
	|	Ведомости.Ссылка КАК ВедомостьПоВыплатеЗП,
	|	ЕСТЬNULL(СписаниеБезналичныхДенежныхСредствВедомостиНаВыплатуЗарплаты.Ссылка, ЗНАЧЕНИЕ(Документ.СписаниеБезналичныхДенежныхСредств.ПустаяСсылка)) КАК ДокументСписание
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыПеречислением.Зарплата КАК Ведомости
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СписаниеБезналичныхДенежныхСредств.ВедомостиНаВыплатуЗарплаты КАК СписаниеБезналичныхДенежныхСредствВедомостиНаВыплатуЗарплаты
	|		ПО Ведомости.Сотрудник.ФизическоеЛицо = СписаниеБезналичныхДенежныхСредствВедомостиНаВыплатуЗарплаты.Ссылка.ПодотчетноеЛицо
	|			И Ведомости.БанковскийСчет = СписаниеБезналичныхДенежныхСредствВедомостиНаВыплатуЗарплаты.Ссылка.БанковскийСчетКонтрагента
	|			И Ведомости.Ссылка = СписаниеБезналичныхДенежныхСредствВедомостиНаВыплатуЗарплаты.Ведомость
	|			И НЕ СписаниеБезналичныхДенежныхСредствВедомостиНаВыплатуЗарплаты.Ссылка.ПометкаУдаления
	|ГДЕ
	|	Ведомости.Ссылка В(&МассивВедомостей)
	|
	|СГРУППИРОВАТЬ ПО
	|	Ведомости.Ссылка,
	|	Ведомости.БанковскийСчет,
	|	ЕСТЬNULL(СписаниеБезналичныхДенежныхСредствВедомостиНаВыплатуЗарплаты.Ссылка, ЗНАЧЕНИЕ(Документ.СписаниеБезналичныхДенежныхСредств.ПустаяСсылка)),
	|	Ведомости.Сотрудник.ФизическоеЛицо";
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ВедомостьНаВыплатуЗарплатыПеречислением") Тогда
		МассивВедомостей = Новый Массив;
		МассивВедомостей.Добавить(Основание);
		Запрос.УстановитьПараметр("МассивВедомостей", МассивВедомостей);
	Иначе
		Запрос.УстановитьПараметр("МассивВедомостей", Основание);
	КонецЕсли;
	
	ТаблицаДокументов.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуДокументовПоФизЛицам()
	
	ТЗФизЛица	= ДокументОснование.ЛицевыеСчетаСотрудников.Выгрузить();
	ТЗФизЛица.Колонки.Добавить("ДокументСписание",);
	МассивФизЛиц	= ТЗФизЛица.ВыгрузитьКолонку("ФизическоеЛицо");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Списания.Ссылка КАК ДокументСписание,
	|	Списания.ПодотчетноеЛицо
	|ИЗ
	|	Документ.СписаниеБезналичныхДенежныхСредств КАК Списания
	|ГДЕ
	|	Списания.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета)
	|	И Списания.ПодотчетноеЛицо В(&МассивФизЛиц)
	|	И Списания.ЗаявкаНаРасходованиеДенежныхСредств = &СсылкаЗаявка";
	
	Запрос.УстановитьПараметр("МассивФизЛиц", МассивФизЛиц);
	Запрос.УстановитьПараметр("СсылкаЗаявка", ДокументОснование);
	ТЗДокСписание = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаФЛ Из ТЗФизЛица Цикл
		
		НайденнаяСтрока = ТЗДокСписание.Найти(СтрокаФЛ.ФизическоеЛицо, "ПодотчетноеЛицо");
		Если НайденнаяСтрока <> Неопределено Тогда
			СтрокаФЛ.ДокументСписание = НайденнаяСтрока.ДокументСписание
		КонецЕсли; 
		
	КонецЦикла; 
	ТаблицаДокументов.Загрузить(ТЗФизЛица);
	
КонецПроцедуры
//-- НЕ УТ

&НаСервере
Процедура СоздатьДокументыСписаниеНаСервере(ФизическоеЛицо, ЛицевойСчет, Сумма, ВедомостьПоВыплатеЗП, ИндексСтроки)
	
	ДокументСписаниеОбъект = Документы.СписаниеБезналичныхДенежныхСредств.СоздатьДокумент();
	ДокументСписаниеОбъект.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета;

	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств") Тогда
		ДокументСписаниеОбъект.Заполнить(ДокументОснование);
		Если ЗначениеЗаполнено(ЛицевойСчет.ТекстНазначения) Тогда
			ДокументСписаниеОбъект.НазначениеПлатежа = ЛицевойСчет.ТекстНазначения;	
		КонецЕсли;
		
		//++ НЕ УТ
	Иначе // заполнение по ВедомостьНаВыплатуЗарплатыПеречислением
		
		ОрганизацияДляЗаполнения	= ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВедомостьПоВыплатеЗП, "Организация").Организация;
		ВалютаДляЗаполнения			= Константы.ВалютаРегламентированногоУчета.Получить();
		ДокументСписаниеОбъект.ТипПлатежногоДокумента	= Перечисления.ТипыПлатежныхДокументов.ПлатежноеПоручение;
		ДокументСписаниеОбъект.Организация		= ОрганизацияДляЗаполнения;
		ДокументСписаниеОбъект.Подразделение	= ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВедомостьПоВыплатеЗП, "Подразделение").Подразделение;
		ДокументСписаниеОбъект.Валюта			= ВалютаДляЗаполнения;
		
		//-- НЕ УТ
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДокументСписаниеОбъект.СтатьяДвиженияДенежныхСредств) Тогда
		ДокументСписаниеОбъект.СтатьяДвиженияДенежныхСредств =
			Справочники.СтатьиДвиженияДенежныхСредств.СтатьяДвиженияДенежныхСредствПоХозяйственнойОперации(
				ДокументСписаниеОбъект.ХозяйственнаяОперация);
	КонецЕсли;
	
	ДокументСписаниеОбъект.Дата                         = ТекущаяДата();
	ДокументСписаниеОбъект.ПодотчетноеЛицо              = ФизическоеЛицо;
	ДокументСписаниеОбъект.БанковскийСчетКонтрагента    = ЛицевойСчет;
	ДокументСписаниеОбъект.СуммаДокумента               = Сумма;
	ДокументСписаниеОбъект.БанковскийСчет               = БанковскийСчет;
	ДокументСписаниеОбъект.ОчередностьПлатежа           = 5;
	
	Если Константы.ИспользоватьНачислениеЗарплаты.Получить() Тогда
		
		НоваяСтрокаТЧСписание           = ДокументСписаниеОбъект.ВедомостиНаВыплатуЗарплаты.Добавить();
		
		НоваяСтрокаТЧСписание.Ведомость = ВедомостьПоВыплатеЗП;
		НоваяСтрокаТЧСписание.Сумма     = Сумма;
		
	КонецЕсли;
	
	ДокументСписаниеОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	ТаблицаДокументов[ИндексСтроки].ДокументСписание	= ДокументСписаниеОбъект.Ссылка;
	ТаблицаДокументов[ИндексСтроки].Отметка				= Ложь;
	
КонецПроцедуры

#КонецОбласти
