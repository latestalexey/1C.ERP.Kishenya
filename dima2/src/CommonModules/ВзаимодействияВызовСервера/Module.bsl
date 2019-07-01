
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
//  Основные процедуры и функции поиска контактов.

// Получает представление и всю контактную информацию контакта.
//
// Параметры:
//  Контакт       - Ссылка - контакт для которого получается информация.
//  Представление - Строка - в данный параметр будет помещено полученное представление.
//  СтрокаКИ      - Строка - в данный параметр будет помещено полученная контактная информация.
//
Процедура ПолучитьПредставлениеИВсюКонтактнуюИнформациюКонтакта(Контакт, Представление, СтрокаКИ,ТипКонтактнойИнформации = Неопределено) Экспорт
	
	Представление = "";
	СтрокаКИ = "";
	Если Не ЗначениеЗаполнено(Контакт) 
		ИЛИ ТипЗнч(Контакт) = Тип("СправочникСсылка.СтроковыеКонтактыВзаимодействий") Тогда
		Контакт = Неопределено;
		Возврат;
	КонецЕсли;
	
	ИмяТаблицы = Контакт.Метаданные().Имя;
	ИмяПоляДляНаименованияВладельца = Взаимодействия.ПолучитьИмяПоляДляНаименованияВладельца(ИмяТаблицы);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Наименование,
	|	" + ИмяПоляДляНаименованияВладельца + " КАК НаименованиеВладельца
	|ИЗ
	|	Справочник." + ИмяТаблицы + " КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка = &Контакт
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Тип КАК Тип,
	|	Таблица.Представление КАК Представление
	|ИЗ
	|	Справочник." + ИмяТаблицы  + ".КонтактнаяИнформация" + " КАК Таблица
	|ГДЕ
	| Таблица.Ссылка = &Контакт" + ?(ТипКонтактнойИнформации = Неопределено,""," И Таблица.Тип = &ТипКонтактнойИнформации");
	
	Запрос.УстановитьПараметр("Контакт", Контакт);
	Запрос.УстановитьПараметр("ТипКонтактнойИнформации", ТипКонтактнойИнформации);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	Выборка = РезультатЗапроса[0].Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	Представление = Выборка.Наименование;
	
	Если Не ПустаяСтрока(Выборка.НаименованиеВладельца) Тогда
		Представление = Представление + " (" + Выборка.НаименованиеВладельца + ")";
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из РезультатЗапроса[1].Выгрузить() Цикл
		Если СтрокаТаблицы.Тип <> Перечисления.ТипыКонтактнойИнформации.Другое Тогда
			СтрокаКИ = СтрокаКИ + ?(ПустаяСтрока(СтрокаКИ), "", "; ") + СтрокаТаблицы.Представление;
		КонецЕсли;
	КонецЦикла;

	
КонецПроцедуры

// Получает наименование и адреса электронной почты контакта.
//
// Параметры:
//  Контакт - Ссылка - контакт, для которого получаются данные.
//
// Возвращаемое значение:
//  Структура - содержит наименование контакта и список значений электронной почты контакта.
//
Функция ПолучитьНаименованиеИАдресаЭлектроннойПочтыКонтакта(Контакт) Экспорт
	
	Если Не ЗначениеЗаполнено(Контакт) 
		Или ТипЗнч(Контакт) = Тип("СправочникСсылка.СтроковыеКонтактыВзаимодействий") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МетаданныеКонтакта = Контакт.Метаданные();
	
	Если МетаданныеКонтакта.Иерархический Тогда
		Если Контакт.ЭтоГруппа Тогда
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	МассивОписанияТиповКонтактов = ВзаимодействияКлиентСервер.ПолучитьМассивОписанияВозможныхКонтактов();
	ЭлементМассиваОписания = Неопределено;
	Для Каждого ЭлементМассива Из МассивОписанияТиповКонтактов Цикл
		
		Если ЭлементМассива.Имя = МетаданныеКонтакта.Имя Тогда
			ЭлементМассиваОписания = ЭлементМассива;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЭлементМассиваОписания = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяТаблицы = МетаданныеКонтакта.ПолноеИмя();
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ЕстьNULL(ТаблицаКонтактнаяИнформация.АдресЭП,"""") КАК АдресЭП,
	|	Таблица." + ЭлементМассиваОписания.ИмяРеквизитаПредставлениеКонтакта + " КАК Наименование
	|ИЗ
	|	" + ИмяТаблицы + " КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ " + ИмяТаблицы + ".КонтактнаяИнформация КАК ТаблицаКонтактнаяИнформация
	|		ПО (ТаблицаКонтактнаяИнформация.Ссылка = Таблица.Ссылка)
	|			И (ТаблицаКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты))
	|ГДЕ
	|	Таблица.Ссылка = &Контакт
	|ИТОГИ ПО
	|	Наименование";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Контакт", Контакт);
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Если Не Выборка.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Адреса = Новый Структура("Наименование,Адреса", Выборка.Наименование, Новый СписокЗначений);
	ВыборкаАдреса = Выборка.Выбрать();
	Пока ВыборкаАдреса.Следующий() Цикл
		Адреса.Адреса.Добавить(ВыборкаАдреса.АдресЭП);
	КонецЦикла;
	
	Возврат Адреса;
	
КонецФункции

// Получает адреса электронной почты контакта.
//
// Параметры:
//  Контакт - Ссылка - контакт, для которого получаются данные.
//
// Возвращаемое значение:
//  Массив - массив структур содержащих адреса, виды и представления адресов.
//
Функция ПолучитьАдресаЭлектроннойПочтыКонтакта(Контакт, ВключатьНезаполненныеВиды = Ложь) Экспорт
	
	Если Не ЗначениеЗаполнено(Контакт) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ИмяМетаданныхКонтакта = Контакт.Метаданные().Имя;
	
	Если ВключатьНезаполненныеВиды Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВидыКонтактнойИнформации.Ссылка КАК Вид,
		|	ВидыКонтактнойИнформации.Наименование КАК ВидНаименование,
		|	Контакты.Ссылка КАК Контакт
		|ПОМЕСТИТЬ КонтактВидыКИ
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации,
		|	Справочник." + ИмяМетаданныхКонтакта + " КАК Контакты
		|ГДЕ
		|	ВидыКонтактнойИнформации.Родитель = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.Справочник" + ИмяМетаданныхКонтакта + ")
		|	И Контакты.Ссылка = &Контакт
		|	И ВидыКонтактнойИнформации.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Представление(КонтактВидыКИ.Контакт) КАК Представление,
		|	ЕСТЬNULL(КонтактнаяИнформация.АдресЭП, """") КАК АдресЭП,
		|	КонтактВидыКИ.Вид,
		|	КонтактВидыКИ.ВидНаименование
		|ИЗ
		|	КонтактВидыКИ КАК КонтактВидыКИ
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник." + ИмяМетаданныхКонтакта + ".КонтактнаяИнформация КАК КонтактнаяИнформация
		|		ПО (КонтактнаяИнформация.Ссылка = КонтактВидыКИ.Контакт)
		|			И (КонтактнаяИнформация.Вид = КонтактВидыКИ.Вид)"
		
	Иначе
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Таблицы.АдресЭП,
		|	Таблицы.Вид,
		|	Таблицы.Представление,
		|	Таблицы.Вид.Наименование КАК ВидНаименование
		|ИЗ
		|	Справочник." + ИмяМетаданныхКонтакта + ".КонтактнаяИнформация КАК Таблицы
		|ГДЕ
		|	Таблицы.Ссылка = &Контакт
		|	И Таблицы.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)";
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Контакт", Контакт);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 0 Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Результат = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Адрес = Новый Структура;
		Адрес.Вставить("АдресЭП",         Выборка.АдресЭП);
		Адрес.Вставить("Вид",             Выборка.Вид);
		Адрес.Вставить("Представление",   Выборка.Представление);
		Адрес.Вставить("ВидНаименование", Выборка.ВидНаименование);
		Результат.Добавить(Адрес);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Выполняет отправку писем пользователя и 
//  получение электронной почты по доступным для пользователя учетным записям.
//
// Параметры:
//  Получено               - Число - в данный параметр будет возвращено количество полученных писем.
//  ДоступноУчетныхЗаписей - Число - в данный параметр будет возвращено количество доступных пользователю учетных
//                                   записей.
//  ЕстьОшибки             - Булево - признак наличия ошибок при получении писем.
//
Процедура ОтправитьЗагрузитьПочтуПользователя(ПолученоПисем, ДоступноУчетныхЗаписей, ЕстьОшибки) Экспорт
	
	УправлениеЭлектроннойПочтой.ОтправитьПочтуПользователя();
	УправлениеЭлектроннойПочтой.ЗагрузитьПочтуПользователя(ПолученоПисем, ДоступноУчетныхЗаписей, ЕстьОшибки)
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////
//  Процедуры и функции работы с взаимодействиями.

// Получает данные выбора для документов взаимодействия.
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка, ИмяДокумента) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ДокументВзаимодействий.Ссылка КАК Ссылка
	|ИЗ
	|	Документ." + ИмяДокумента + " КАК ДокументВзаимодействий
	|ГДЕ
	|	ДокументВзаимодействий.Тема ПОДОБНО &СтрокаПоиска
	|	ИЛИ ДокументВзаимодействий.Номер ПОДОБНО &СтрокаПоиска";
	
	Запрос.УстановитьПараметр("СтрокаПоиска", Параметры.СтрокаПоиска + "%");
	
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
//  Прочее

// Заменяет предмет в цепочке взаимодействий.
//
// Параметры:
//  Цепочка   - Ссылка - предмет взаимодействий который будет заменен.
//  Предмет	  - Ссылка - предмет, на который будет выполнена замена.
//  Исключать - Ссылка - взаимодействие, в котором операция замены выполнена не будет.
//
Процедура ЗаменитьПредметВЦепочкеВзаимодействий(Цепочка, Предмет, Исключать = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивВзаимодействий = Взаимодействия.ПолучитьВзаимодействияИзЦепочки(Цепочка, Исключать);
	
	УстановитьПредметДляМассиваВзаимодействий(МассивВзаимодействий, Предмет);
	
КонецПроцедуры

// Устанавливает предмет для массива взаимодействий.
//
// Параметры:
//  МассивВзаимодействий - Массив - массив взаимодействий для которых будет установлен предмет.
//  Предмет  - Ссылка - предмет, на который будет выполнена замена.
//  ПроверятьНаличиеДругихЦепочек - Булево - если Истина, то будет выполнена замена предмета и для взаимодействий,
//                                           которые входят в  цепочки взаимодействий первым взаимодействием которых
//                                           является взаимодействие входящее в массив.
//
Процедура УстановитьПредметДляМассиваВзаимодействий(МассивВзаимодействий, Предмет, ПроверятьНаличиеДругихЦепочек = Ложь) Экспорт

	Если ПроверятьНаличиеДругихЦепочек Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПредметыВзаимодействий.Взаимодействие КАК Ссылка
		|ИЗ
		|	РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыВзаимодействий
		|ГДЕ
		|	НЕ (НЕ ПредметыВзаимодействий.Предмет В (&МассивВзаимодействий)
		|			И НЕ ПредметыВзаимодействий.Взаимодействие В (&МассивВзаимодействий))";
		
		Запрос.УстановитьПараметр("МассивВзаимодействий", МассивВзаимодействий);
		МассивВзаимодействий = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
	КонецЕсли;
	
	Если ТипЗнч(Предмет) = Тип("РегистрСведенийКлючЗаписи.СостоянияПредметовВзаимодействий") Тогда
		Предмет = Предмет.Предмет;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПредметыПапкиВзаимодействий.Предмет
	|ИЗ
	|	РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|ГДЕ
	|	ПредметыПапкиВзаимодействий.Взаимодействие В(&МассивВзаимодействий)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Предмет";
	
	Запрос.УстановитьПараметр("Предмет", Предмет);
	Запрос.УстановитьПараметр("МассивВзаимодействий", МассивВзаимодействий);
	
	ВыборкаПредметы = Запрос.Выполнить().Выбрать();
	
	Для Каждого Взаимодействие Из МассивВзаимодействий Цикл
		Взаимодействия.УстановитьПредмет(Взаимодействие, Предмет, Ложь);
	КонецЦикла;
	
	Взаимодействия.РассчитатьРассмотреноПоПредметам(Взаимодействия.ТаблицаДанныхДляРасчетаРассмотрено(ВыборкаПредметы, "Предмет"));
	
КонецПроцедуры

// Устанавливает папку электронного письма.
// Параметры:
//  Ссылка  - ссылка на письмо,
//  Папка - устанавливаемая папка электронного письма.
//
Процедура УстановитьПапкуЭлектронногоПисьма(Ссылка, Папка, РассчитыватьРассмотрено = Истина) Экспорт
	
	ЗаписьРегистрРеквизитыВзаимодействия(Ссылка, ВзаимодействияКлиентСервер.СтруктураРеквизитовВзаимодействияДляЗаписи(Папка,,,,РассчитыватьРассмотрено));
	
КонецПроцедуры

// Устанавливает папку, предмет и реквизиты рассмотрения для взаимодействий.
//
// Параметры:
//  Ссылка      - ДокументСсылка.ЭлектронноеПисьмоВходящее,
//                ДокументСсылка.ЭлектронноеПисьмоИсходящее,
//                ДокументСсылка.Встреча,
//                ДокументСсылка.ЗапланированноеВзаимодействие,
//                ДокументСсылка.ТелефонныйЗвонок - взаимодействие для которого будут установлены папка и предмет.
//  Реквизиты    - Структура - содержит данные реквизитов взаимодействия, которые хранятся в регистре.
//  НаборЗаписей - РегистрСведений.ПредметыПапкиВзаимодействий.НаборЗаписей - набор записей регистра, если он уже создан
//                 на момент вызова процедуры.
//
Процедура ЗаписьРегистрРеквизитыВзаимодействия(Взаимодействие, Реквизиты, НаборЗаписей = Неопределено) Экспорт
	
	Папка                   = Реквизиты.Папка;
	Предмет                 = Реквизиты.Предмет;
	Рассмотрено             = Реквизиты.Рассмотрено;
	РассмотретьПосле        = Реквизиты.РассмотретьПосле;
	РассчитыватьРассмотрено = Реквизиты.РассчитыватьРассмотрено;
	
	СоздаватьИЗаписывать = (НаборЗаписей = Неопределено);
	
	Если Папка = Неопределено И Предмет = Неопределено И Рассмотрено = Неопределено 
		И РассмотретьПосле = Неопределено  Тогда
		
		Возврат;
		
	ИначеЕсли Папка = Неопределено ИЛИ Предмет = Неопределено ИЛИ Рассмотрено = Неопределено 
		ИЛИ РассмотретьПосле = Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ПредметыПапкиВзаимодействий.Предмет,
		|	ПредметыПапкиВзаимодействий.ПапкаЭлектронногоПисьма,
		|	ПредметыПапкиВзаимодействий.Рассмотрено,
		|	ПредметыПапкиВзаимодействий.РассмотретьПосле
		|ИЗ
		|	РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
		|ГДЕ
		|	ПредметыПапкиВзаимодействий.Взаимодействие = &Взаимодействие";
		
		Запрос.УстановитьПараметр("Взаимодействие",Взаимодействие);
		
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			Если Папка = Неопределено Тогда
				Папка = Выборка.ПапкаЭлектронногоПисьма;
			КонецЕсли;
			
			Если Предмет = Неопределено Тогда
				Предмет = Выборка.Предмет;
			КонецЕсли;
			
			Если Рассмотрено = Неопределено Тогда
				Рассмотрено = Выборка.Рассмотрено;
			КонецЕсли;
			
			Если РассмотретьПосле = Неопределено Тогда
				РассмотретьПосле = Выборка.РассмотретьПосле;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если СоздаватьИЗаписывать Тогда
		НаборЗаписей = РегистрыСведений.ПредметыПапкиВзаимодействий.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Взаимодействие.Установить(Взаимодействие);
	КонецЕсли;
	Запись = НаборЗаписей.Добавить();
	Запись.Взаимодействие          = Взаимодействие;
	Запись.Предмет                 = Предмет;
	Запись.ПапкаЭлектронногоПисьма = Папка;
	Запись.Рассмотрено             = Рассмотрено;
	Запись.РассмотретьПосле        = РассмотретьПосле;
	НаборЗаписей.ДополнительныеСвойства.Вставить("РассчитыватьРассмотрено", РассчитыватьРассмотрено);
	
	Если СоздаватьИЗаписывать Тогда
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
