
#Область СлужебныеПроцедурыИФункции


Процедура УстановитьФиксРасчетСтрокНДФЛ(Форма, СтруктураПоиска) Экспорт
	
	ОписаниеПанелиВычеты = Форма.ОписаниеПанелиВычетыНаСервере();

	ДанныеНДФЛ = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ПутьКДаннымНДФЛ);
	СтрокиНДФЛ = ДанныеНДФЛ.НайтиСтроки(СтруктураПоиска);
	Для Каждого СтрокаНДФЛ Из СтрокиНДФЛ Цикл
		СтрокаНДФЛ.ФиксРасчет = Истина;
	КонецЦикла;
		
КонецПроцедуры

Процедура ОбработатьСообщенияПроверкиЗаполнения(Форма, ОписаниеТаблицы) Экспорт
	
	МассивИдентификаторовСтрок = Новый Массив;
	
	СообщенияПроверкиЗаполнения = ПолучитьСообщенияПользователю();
	Если СообщенияПроверкиЗаполнения <> Неопределено Тогда
		
		ДанныеТабличнойЧасти = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ОписаниеТаблицы.ПутьКДанным);
		Для каждого СообщениеПроверки Из СообщенияПроверкиЗаполнения Цикл
			Если СтрНайти(СообщениеПроверки.Поле,  ОписаниеТаблицы.ИмяТаблицы + "[") > 0 Тогда
				
				ПолеСЛева = Сред(СообщениеПроверки.Поле, СтрНайти(СообщениеПроверки.Поле,  "[") + 1);
				Попытка
					ИндексСтроки = Число(Лев(ПолеСЛева, СтрНайти(ПолеСЛева,  "]") - 1));
					МассивИдентификаторовСтрок.Добавить(ДанныеТабличнойЧасти[ИндексСтроки].ПолучитьИдентификатор());
				Исключение
					
				КонецПопытки;
				
			КонецЕсли; 
		КонецЦикла;
		
	КонецЕсли; 
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "МассивИдентификаторовСтрокНДФЛСОшибками", Новый ФиксированныйМассив(МассивИдентификаторовСтрок));
	
КонецПроцедуры

Функция СведенияОбНДФЛ(Форма, ФизическоеЛицо = Неопределено, ПутьКДаннымАдресРаспределенияРезультатовВХранилище = Неопределено, ТаблицаНачислений= Неопределено) Экспорт
	
	ДанныеОбНДФЛ = Новый Структура;
	Если ФизическоеЛицо = Неопределено Тогда
		
		КоллекцияСтрокНДФЛ = Форма.Объект.НДФЛ.Выгрузить();
		
		Если ТаблицаНачислений <> Неопределено Тогда
			ДанныеОбНДФЛ.Вставить("Начисления", ТаблицаНачислений);
		КонецЕсли; 
		
	Иначе
		
		СтруктураОтбора = Новый Структура("ФизическоеЛицо", ФизическоеЛицо);
		КоллекцияСтрокНДФЛ = Форма.Объект.НДФЛ.Выгрузить(СтруктураОтбора);
		
		ДанныеОбНДФЛ.Вставить("Начисления", Форма.Объект.Начисления.Выгрузить(СтруктураОтбора));
		
	КонецЕсли;
	
	ДанныеОбНДФЛ.Вставить("НДФЛ", КоллекцияСтрокНДФЛ);
	
	Если ПутьКДаннымАдресРаспределенияРезультатовВХранилище <> Неопределено Тогда
		ДанныеОбНДФЛ.Вставить("АдресРаспределенияРезультатовВХранилище", Форма[ПутьКДаннымАдресРаспределенияРезультатовВХранилище]);
	КонецЕсли; 
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеОбНДФЛ, Форма.УникальныйИдентификатор);
	
КонецФункции


Процедура УстановитьПараметрыВыбораСотрудниковВДокументахПредоставленияЛьгот(Форма, ИмяЭлементаСотрудник) Экспорт
	
	ЭлементФормы = Форма.Элементы.Найти(ИмяЭлементаСотрудник);
	Если ЭлементФормы <> Неопределено Тогда
		
		ОтборУстановлен = Ложь;
		
		ПараметрыВыбора = Новый Массив(ЭлементФормы.ПараметрыВыбора);
		Для каждого ПараметрВыбора Из ПараметрыВыбора Цикл
			
			Если ВРег(ПараметрВыбора.Имя) = ВРег("Отбор.Роль") Тогда
				
				ОтборУстановлен = Истина;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если Не ОтборУстановлен Тогда
			
			РолиСотрудника = Новый Массив;
			РолиСотрудника.Добавить(Перечисления.РолиФизическихЛиц.Сотрудник);
			РолиСотрудника.Добавить(Перечисления.РолиФизическихЛиц.БывшийСотрудник);
			РолиСотрудника.Добавить(Перечисления.РолиФизическихЛиц.ПрочийПолучательДоходов);
			
			ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Роль", Новый ФиксированныйМассив(РолиСотрудника)));
			
			ЭлементФормы.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
			
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

Функция РасчетНДФЛНарастающимИтогомСНачалаГода(ОбъектКодомДоходаНДФЛ) Экспорт
	
	Возврат Истина;
	
КонецФункции

Функция РасчетНДФЛПоКодуДохода(ОбъектКодомДоходаНДФЛ) Экспорт
	
	РасчетНДФЛПоКодуДохода = Ложь;
	
	Если ЗначениеЗаполнено(ОбъектКодомДоходаНДФЛ) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		КодДоходаНДФЛ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектКодомДоходаНДФЛ, "КодДоходаНДФЛ");
		Если ЗначениеЗаполнено(КодДоходаНДФЛ) Тогда
			ВидСтавкиРезидента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КодДоходаНДФЛ, "ВидСтавкиРезидента");
			РасчетНДФЛПоКодуДохода = (ВидСтавкиРезидента <> Перечисления.ВидыСтавокНДФЛ.НеОблагается);
		КонецЕсли; 
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	Возврат РасчетНДФЛПоКодуДохода;

	
КонецФункции

Функция ФормаПодробнееОРасчетеНДФЛКонтролируемыеПоляДляФиксацииРезультатов() Экспорт
	
	Возврат Новый Структура("НДФЛ", УчетНДФЛРасширенный.КонтролируемыеПоляДляФиксацииРезультатов());
	
КонецФункции

Процедура ФормаПодробнееОРасчетеНДФЛПриЗаполнении(Форма, ОписаниеТаблицыНДФЛ, ОписанияТаблицДляРаспределения) Экспорт
	
	РасчетЗарплатыРасширенныйФормы.ДокументыВыполненияНачисленийДополнитьФорму(Форма, ОписаниеТаблицыНДФЛ, "");
	РасчетЗарплатыРасширенныйФормы.ДокументыНачисленийДополнитьФормуРезультатыРаспределения(Форма, ОписанияТаблицДляРаспределения);
	
КонецПроцедуры

#КонецОбласти
