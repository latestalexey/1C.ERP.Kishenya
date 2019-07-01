

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	УправлениеЭлементами();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда
		// Изменены настройки программы в панелях администрирования
		УправлениеЭлементами();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ОбщиеСправочники

&НаКлиенте
Процедура ОткрытьВидыНоменклатуры(Команда)
	
	ОткрытьФорму("Справочник.ВидыНоменклатуры.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьГруппыДоступаНоменклатуры(Команда)
	
	ОткрытьФорму("Справочник.ГруппыДоступаНоменклатуры.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЕдиницыИзмерения(Команда)
	
	Отбор = Новый Структура;
	Отбор.Вставить("Владелец",ПредопределенноеЗначение("Справочник.НаборыУпаковок.БазовыеЕдиницыИзмерения"));
	ПараметрыФормыСправочника = Новый Структура("Отбор", Отбор);
	
	ОткрытьФорму("Справочник.УпаковкиЕдиницыИзмерения.ФормаСписка",
		ПараметрыФормыСправочника,
		ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНаборыУпаковок(Команда)
	
	ОткрытьФорму("Справочник.НаборыУпаковок.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПолитикиУчетаСерий(Команда)
	
	ОткрытьФорму("Справочник.ПолитикиУчетаСерий.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСкладскиеГруппыНоменклатуры(Команда)
	
	ОткрытьФорму("Справочник.СкладскиеГруппыНоменклатуры.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСкладскиеГруппыУпаковок(Команда)
	
	ОткрытьФорму("Справочник.СкладскиеГруппыУпаковок.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТипоразмерыУпаковок(Команда)
	
	ОткрытьФорму("Справочник.ТипоразмерыУпаковок.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЦеновыеГруппы(Команда)
	
	ОткрытьФорму("Справочник.ЦеновыеГруппы.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСезонныеГруппы(Команда)
	
	ОткрытьФорму("Справочник.СезонныеГруппы.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьГруппыФинансовогоУчетаНоменклатуры(Команда)

	ОткрытьФорму("Справочник.ГруппыФинансовогоУчетаНоменклатуры.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьГруппыАналитическогоУчетаНоменклатуры(Команда)
	
	ОткрытьФорму("Справочник.ГруппыАналитическогоУчетаНоменклатуры.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеЭлементами()

	//Функциональные опции
	БазоваяВерсия 						 	 = ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	ИспользоватьГруппыНоменклатуры         	 = ПолучитьФункциональнуюОпцию("ИспользоватьГруппыДоступаНоменклатуры");
	ИспользоватьУпаковкиНоменклатуры       	 = ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры");
	ИспользоватьЦеновыеГруппы              	 = ПолучитьФункциональнуюОпцию("ИспользоватьЦеновыеГруппы");
	ИспользоватьГруппыДоступаНоменклатуры  	 = ПолучитьФункциональнуюОпцию("ИспользоватьГруппыДоступаНоменклатуры");
	ИспользоватьСерииНоменклатуры          	 = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	ИспользоватьАдресноеХранение           	 = ПолучитьФункциональнуюОпцию("ИспользоватьАдресноеХранение", Новый Структура);
	ИспользоватьНесколькоОрганизаций       	 = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	ИспользоватьНесколькоВалют             	 = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	ИспользоватьНесколькоСкладов           	 = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	ИспользоватьРозничныеПродажи           	 = ПолучитьФункциональнуюОпцию("ИспользоватьРозничныеПродажи");
	ИспользоватьНесколькоКассККМ             = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКассККМ");
	ИспользоватьОбменЭД                    	 = ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭД");
	ИспользоватьСезонныеКоэффициенты       	 = ПолучитьФункциональнуюОпцию("ИспользоватьСезонныеКоэффициенты");
	ИспользоватьНесколькоКасс              	 = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	ИспользоватьНесколькоРасчетныхСчетов	 = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов");
	ИспользоватьГруппыАналитическогоУчета	 = ПолучитьФункциональнуюОпцию("ИспользоватьГруппыАналитическогоУчетаНоменклатуры");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Склады.Ссылка
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	Склады.ИспользоватьАдресноеХранение
	|	И НЕ Склады.ЭтоГруппа
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СкладскиеПомещения.Ссылка
	|ИЗ
	|	Справочник.СкладскиеПомещения КАК СкладскиеПомещения
	|ГДЕ
	|	СкладскиеПомещения.ИспользоватьАдресноеХранение";
	
	УстановитьПривилегированныйРежим(Истина);
	ИспользоватьАдресноеХранение = Не Запрос.Выполнить().Пустой();
	УстановитьПривилегированныйРежим(Ложь);
	
	
	//Право чтения
	ПравоДоступаПроизводственныеКалендари   = ПравоДоступа("Просмотр", Метаданные.Справочники.ПроизводственныеКалендари);
	ПравоДоступаУпаковки                    = ПравоДоступа("Просмотр", Метаданные.Справочники.УпаковкиЕдиницыИзмерения);
	ПравоДоступаНаборыУпаковок              = ПравоДоступа("Просмотр", Метаданные.Справочники.НаборыУпаковок);
	ПравоДоступаЕдиницыИзмерения            = ПравоДоступа("Просмотр", Метаданные.Справочники.УпаковкиЕдиницыИзмерения);
	ПравоДоступаГруппыДоступаНоменклатуры   = ПравоДоступа("Просмотр", Метаданные.Справочники.ГруппыДоступаНоменклатуры);
	ПравоДоступаСкладскиеГруппыУпаковок     = ПравоДоступа("Просмотр", Метаданные.Справочники.СкладскиеГруппыУпаковок);
	ПравоДоступаВидыНоменклатуры            = ПравоДоступа("Просмотр", Метаданные.Справочники.ВидыНоменклатуры);
	ПравоДоступаПолитикиУчетаСерий          = ПравоДоступа("Просмотр", Метаданные.Справочники.ПолитикиУчетаСерий);
	ПравоДоступаТипоразмерыУпаковок         = ПравоДоступа("Просмотр", Метаданные.Справочники.ТипоразмерыУпаковок);
	ПравоДоступаЦеновыеГруппы               = ПравоДоступа("Просмотр", Метаданные.Справочники.ЦеновыеГруппы);
	ПравоДоступаСезонныеГруппы              = ПравоДоступа("Просмотр", Метаданные.Справочники.СезонныеГруппы);
	ПравоДоступаГруппыАналитическогоУчета   = ПравоДоступа("Просмотр", Метаданные.Справочники.ГруппыАналитическогоУчетаНоменклатуры);
	ПравоДоступаКлассификаторыУКТВЭД		= ПравоДоступа("Просмотр", Метаданные.Справочники.КлассификаторУКТВЭД);
	
	ПравоДоступаСкладскиеГруппыНоменклатуры                 = ПравоДоступа("Просмотр", Метаданные.Справочники.СкладскиеГруппыНоменклатуры);
	ПравоДоступаСкладскиеГруппыДоступаНоменклатуры          = ПравоДоступа("Просмотр", Метаданные.Справочники.ГруппыДоступаНоменклатуры);
		
	ПравоДоступаОрганизации = ПравоДоступа("Просмотр", Метаданные.Справочники.Организации);
	ПравоДоступаВалюты      = ПравоДоступа("Просмотр", Метаданные.Справочники.Валюты);
	ПравоДоступаСклады      = ПравоДоступа("Просмотр", Метаданные.Справочники.Склады);
	ПравоДоступаКассыККМ    = ПравоДоступа("Просмотр", Метаданные.Справочники.КассыККМ);
	
	ПравоДоступаСоглашенияОбИспользованииЭД = ПравоДоступа("Просмотр", Метаданные.Справочники.СоглашенияОбИспользованииЭД);
	
	ПравоДоступаВидыКонтактнойИнформации = ПравоДоступа("Просмотр", Метаданные.Справочники.ВидыКонтактнойИнформации);

	//Номенклатура
	Элементы.ГруппаВидыНоменклатуры.Видимость = ПравоДоступаВидыНоменклатуры;
	Элементы.ГруппаПолитикиУчетаСерий.Видимость = ИспользоватьСерииНоменклатуры
		И ПравоДоступаПолитикиУчетаСерий;
	Элементы.ГруппаЕдиницыИзмерения.Видимость = ПравоДоступаЕдиницыИзмерения;
	Элементы.ГруппаНаборыУпаковок.Видимость = ИспользоватьУпаковкиНоменклатуры
		И ПравоДоступаНаборыУпаковок;
	Элементы.ГруппаСкладскиеГруппыНоменклатуры.Видимость = ИспользоватьАдресноеХранение
		И ПравоДоступаСкладскиеГруппыНоменклатуры;
	Элементы.ГруппаСкладскиеГруппыУпаковок.Видимость = ИспользоватьАдресноеХранение
		И ПравоДоступаСкладскиеГруппыУпаковок;
	Элементы.ГруппаТипоразмерыУпаковок.Видимость = ПравоДоступаТипоразмерыУпаковок
		И ИспользоватьУпаковкиНоменклатуры;
	Элементы.ГруппаЦеновыеГруппы.Видимость = ИспользоватьЦеновыеГруппы
		И ПравоДоступаЦеновыеГруппы;
	Элементы.ГруппаГруппыДоступаНоменклатуры.Видимость = ИспользоватьГруппыДоступаНоменклатуры
		И ПравоДоступаГруппыДоступаНоменклатуры;
	Элементы.ГруппаСезонныеГруппы.Видимость = ИспользоватьСезонныеКоэффициенты И ПравоДоступаСезонныеГруппы;
	Элементы.ОткрытьГруппыАналитическогоУчетаНоменклатуры.Видимость = ИспользоватьГруппыАналитическогоУчета
		И ПравоДоступаГруппыАналитическогоУчета;
	Элементы.ОткрытьКлассификаторУКТВЭД.Видимость = ПравоДоступаКлассификаторыУКТВЭД;
	
	//Обмен электронными документами
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ГруппаОбменЭлектроннымиДокументами", "Видимость", ИспользоватьОбменЭД И ПравоДоступаСоглашенияОбИспользованииЭД);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ГруппаПроизводственныеКалендари", "Видимость", ПравоДоступаПроизводственныеКалендари);
		
	НесколькоВидовНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовНоменклатуры");
	Элементы.ВидыНоменклатуры.Видимость					= НесколькоВидовНоменклатуры;
	Элементы.ДекорацияВидыНоменклатуры.Видимость		= НесколькоВидовНоменклатуры;
	Элементы.ОткрытьВидНоменклатурыТовар.Видимость 		= Не НесколькоВидовНоменклатуры;
	Элементы.ОткрытьВидНоменклатурыУслуга.Видимость 	= Не НесколькоВидовНоменклатуры;
		
КонецПроцедуры

#Область Прочее

&НаКлиенте
Процедура ОткрытьВидНоменклатурыТовар(Команда)
	
	Ключ = ПолучитьПредустановленныеВидыНоменклатуры(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"),НСтр("ru='Товар';uk='Товар'"));
	ОткрытьФорму("Справочник.ВидыНоменклатуры.ФормаОбъекта", Новый Структура("Ключ", Ключ));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидНоменклатурыУслуга(Команда)
	
	Ключ = ПолучитьПредустановленныеВидыНоменклатуры(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Услуга"),НСтр("ru='Услуга';uk='Послуга'"));
	ОткрытьФорму("Справочник.ВидыНоменклатуры.ФормаОбъекта", Новый Структура("Ключ", Ключ));
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПредустановленныеВидыНоменклатуры(ТипНоменклатуры, Имя)
	
	МассивВидов = Новый Массив();
	
	Справочники.ВидыНоменклатуры.ДобавитьПредустановленныйВидНоменклатуры(МассивВидов, ТипНоменклатуры, Имя);
	
	Если МассивВидов.Количество() > 0 Тогда
		Возврат МассивВидов[0];
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции 

&НаКлиенте
Процедура ОткрытьКлассификаторУКТВЭД	(Команда)
	ОткрытьФорму("Справочник.КлассификаторУКТВЭД.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#КонецОбласти
