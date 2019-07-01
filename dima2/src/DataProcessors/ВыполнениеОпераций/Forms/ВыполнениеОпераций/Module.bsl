
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВосстановитьНастройкиФормы();
	
	НастроитьРеквизитыФормыПриСоздании();
	
	УстановитьОтборыСпискаОперацийПриСоздании();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Элементы.ОперацииПланирование.АвтоОбновление Тогда
		Если Элементы.ОперацииПланирование.ПериодАвтоОбновления > 30 Тогда
			ИнтервалОбновления = Элементы.ОперацииПланирование.ПериодАвтоОбновления-30;
		Иначе
			ИнтервалОбновления = Элементы.ОперацииПланирование.ПериодАвтоОбновления;
		КонецЕсли;
	Иначе
		ИнтервалОбновления = 60;
	КонецЕсли;
	ПодключитьОбработчикОжидания("ОбновитьПараметрыЗапросаОперацииПланирование", ИнтервалОбновления);
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ОперативныйУчетПроизводстваКлиент.ИмяСобытияИзменениеПооперационногоРасписания() Тогда 
		
		ОбновитьСписокОпераций();
		
	ИначеЕсли ИмяСобытия = ОперативныйУчетПроизводстваКлиент.ИмяСобытияИзменениеСтатусаОпераций() Тогда
		
		ИсточникЭтотОбъект = ТипЗнч(Источник) = Тип("УправляемаяФорма") И Источник = ЭтотОбъект;
		Если НЕ ИсточникЭтотОбъект Тогда
			ОбновитьСписокОпераций();
		КонецЕсли;
		
	КонецЕсли;
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	ОтборПодразделениеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОтбораРабочийЦентрПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ОтборРабочийЦентр) Тогда
		ЗначениеОтбораДоИзменения = ОтборРабочийЦентр;
	Иначе
		ЗначениеОтбораДоИзменения = Неопределено;
	КонецЕсли;
	
	НастроитьТипЗначенияОтборРабочийЦентр(ЭтотОбъект);
	
	Если НЕ ЗначениеОтбораДоИзменения = Неопределено Тогда
		Если НЕ ОтборРабочийЦентр = ЗначениеОтбораДоИзменения Тогда
			ОтборРабочийЦентрПриИзменении(Элементы.ОтборРабочийЦентр);
		Иначе
			СохранитьНастройкиФормы();
		КонецЕсли;
	Иначе
		СохранитьНастройкиФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборРабочийЦентрПриИзменении(Элемент)
	
	ОтборРабочийЦентрПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтборСостояниеНачалоВыбораЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыбранныеЗначения", ОтборСостояние);
	
	ОткрытьФорму("Обработка.ВыполнениеОпераций.Форма.ОтборСостоянияВыполнения",
		ПараметрыФормы,
		ЭтотОбъект,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	ОтборСостояниеПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОперацииПланирование

&НаКлиенте
Процедура ОперацииПланированиеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьМаршрутныйЛистОперации("ОперацииПланирование", ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОперацииРегистрация

&НаКлиенте
Процедура ОперацииРегистрацияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьМаршрутныйЛистОперации("ОперацииРегистрация", ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьДанные(Команда)
	
	ОбновитьСписокОпераций();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнениеНачалось(Команда)
	
	ИзменитьСтатусОпераций(ПредопределенноеЗначение("Перечисление.СтатусыВыполненияОпераций.Начато"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнениеНеНачалось(Команда)
	
	ИзменитьСтатусОпераций(ПредопределенноеЗначение("Перечисление.СтатусыВыполненияОпераций.НеНачато"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнениеЗавершено(Команда)
	
	ИзменитьСтатусОпераций(ПредопределенноеЗначение("Перечисление.СтатусыВыполненияОпераций.Завершено"));
	
КонецПроцедуры

&НаКлиенте
Процедура НазначитьРабочийЦентр(Команда)
	
	Если ДопустимоНазначениеРабочегоЦентра() Тогда
		
		Если ЗначениеЗаполнено(ОтборРабочийЦентр)
			И ТипЗнч(ОтборРабочийЦентр) = Тип("СправочникСсылка.РабочиеЦентры") Тогда
			
			НазначитьРабочийЦентрНаСервере(ВыделенныеОперации(), ОтборРабочийЦентр);
			ОбновитьСписокОпераций();
			
		Иначе
			
			Если ЗначениеЗаполнено(ОтборРабочийЦентр)
				И ТипЗнч(ОтборРабочийЦентр) = Тип("СправочникСсылка.ВидыРабочихЦентров") Тогда
				ВидРабочегоЦентра = ОтборРабочийЦентр;
			Иначе
				ВыделеннаяСтрока = Элементы.ОперацииРегистрация.ВыделенныеСтроки[0];
				ВидРабочегоЦентра = Элементы.ОперацииРегистрация.ДанныеСтроки(ВыделеннаяСтрока).ВидРабочегоЦентра;
			КонецЕсли;
			
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"ВыборРабочегоЦентраДляНазначенияЗавершение",
				ЭтотОбъект);
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("РежимВыбора", Истина);
			Отбор = Новый Структура("ВидРабочегоЦентра", ВидРабочегоЦентра);
			ПараметрыФормы.Вставить("Отбор", Отбор);
			
			ОткрытьФорму("Справочник.РабочиеЦентры.ФормаВыбора",
				ПараметрыФормы,
				ЭтотОбъект,,,,
				ОписаниеОповещения,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		Конецесли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьНазначениеРабочегоЦентра(Команда)
	
	Операции = ВыделенныеОперации();
	Если ЗначениеЗаполнено(Операции) Тогда
		
		НазначитьРабочийЦентрНаСервере(
			Операции,
			ПредопределенноеЗначение("Справочник.РабочиеЦентры.ПустаяСсылка"));
		
		ОбновитьСписокОпераций();
		
	Иначе
		
		ПоказатьПредупреждениеНеВыбранаОперация();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВводФактаИлиОтклонений(Команда)
	
	Если РегистрацияОпераций(ЭтотОбъект) Тогда
		ТекущиеДанные = Элементы.ОперацииРегистрация.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.ОперацииПланирование.ТекущиеДанные;
	КонецЕсли;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("МаршрутныйЛист",    ТекущиеДанные.МаршрутныйЛист);
		ПараметрыФормы.Вставить("КлючСвязи",         ТекущиеДанные.ИдентификаторОперации);
		ОткрытьФорму("Обработка.ВводФактаПоМаршрутномуЛисту.Форма", ПараметрыФормы,,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область НастройкаФормыПриСоздании

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СпискиОпераций = Новый Массив;
	СпискиОпераций.Добавить(ОперацииПланирование);
	СпискиОпераций.Добавить(ОперацииРегистрация);
	
	Для каждого Список Из СпискиОпераций Цикл
		
		Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Очистить();
		
		//
		
		Элемент = Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("МаршрутныйЛист.Дата");
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Формат", "ДЛФ='D'");
		Элемент.Использование = Истина;
		Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
		//
		
		Элемент = Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Состояние");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		СписокЗначений = Новый СписокЗначений;
		СписокЗначений.Добавить(Перечисления.СостоянияВыполненияОпераций.ОжиданиеПредшествующих);
		СписокЗначений.Добавить(Перечисления.СостоянияВыполненияОпераций.НачатаПредшествующая);
		ОтборЭлемента.ПравоеЗначение = СписокЗначений;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СерыйЦветТекста1);
		Элемент.Использование = Истина;
		Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
		
		//
		
	КонецЦикла;
	
	//
	
	Элемент = ОперацииПланирование.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Начало");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Окончание");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Формат", "ДФ='dd.MM.yyyy ЧЧ:мм'");
	Элемент.Использование = Истина;
	Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьРеквизитыФормыПриСоздании()
	
	НастроитьФормуПоПодразделению(ЭтотОбъект);
	
	НастроитьТипЗначенияОтборРабочийЦентр(ЭтотОбъект);
	
	ОперацииПланирование.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	
	ДоступныеМетодикиУправления.Добавить(Перечисления.УправлениеМаршрутнымиЛистами.ПооперационноеПланирование);
	ДоступныеМетодикиУправления.Добавить(Перечисления.УправлениеМаршрутнымиЛистами.РегистрацияОпераций);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыЗапросаОперацииПланирование()
	
	ОперацииПланирование.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыСпискаОперацийПриСоздании()
	
	УстановитьОтборПодразделение();
	
	Если ЗначениеЗаполнено(ОтборРабочийЦентр) Тогда
		УстановитьОтборРабочийЦентр();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборСостояние) Тогда
		УстановитьОтборСостояние();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПодразделение()
	
	Если УправлениеМаршрутнымиЛистами = Перечисления.УправлениеМаршрутнымиЛистами.ПооперационноеПланирование Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ОперацииПланирование, 
			"Подразделение", 
			ОтборПодразделение, 
			ВидСравненияКомпоновкиДанных.Равно,
			, // Представление - автоматически
			Истина);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ОперацииРегистрация, 
			"Подразделение",
			ОтборПодразделение, 
			ВидСравненияКомпоновкиДанных.Равно,
			, // Представление - автоматически
			Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборРабочийЦентр()
	
	Если УправлениеМаршрутнымиЛистами = Перечисления.УправлениеМаршрутнымиЛистами.ПооперационноеПланирование Тогда
		ОперацииПланированиеОтобратьПоРабочемуЦентру();
	Иначе
		ОперацииРегистрацияОтобратьПоРабочемуЦентру();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОперацииПланированиеОтобратьПоРабочемуЦентру()
	
	ОтборНаРЦ = ЗначениеЗаполнено(ОтборРабочийЦентр)
		И ТипЗнч(ОтборРабочийЦентр) = Тип("СправочникСсылка.РабочиеЦентры");
	
	ОтборНаВРЦ = ЗначениеЗаполнено(ОтборРабочийЦентр)
		И ТипЗнч(ОтборРабочийЦентр) = Тип("СправочникСсылка.ВидыРабочихЦентров");
	
	// Установка отбора на список ОперацииПланирование.
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ОперацииПланирование,
		"РабочийЦентр",
		ОтборРабочийЦентр, 
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ОтборНаРЦ);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ОперацииПланирование,
		"ВидРабочегоЦентра",
		ОтборРабочийЦентр, 
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ОтборНаВРЦ);
	
КонецПроцедуры

&НаСервере
Процедура ОперацииРегистрацияОтобратьПоРабочемуЦентру()
	
	ОтборНаРЦ = ЗначениеЗаполнено(ОтборРабочийЦентр)
		И ТипЗнч(ОтборРабочийЦентр) = Тип("СправочникСсылка.РабочиеЦентры");
	
	ОтборНаВРЦ = ЗначениеЗаполнено(ОтборРабочийЦентр)
		И ТипЗнч(ОтборРабочийЦентр) = Тип("СправочникСсылка.ВидыРабочихЦентров");
		
	КоллекцияЭлементовОтобра = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(
		ОперацииРегистрация.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
		,
		"ОтборПоРабочемуЦентру");
	
	Если ОтборНаРЦ ИЛИ ОтборНаВРЦ Тогда
		
		Если КоллекцияЭлементовОтобра.Количество() > 0 Тогда
			ГруппаЭлементовОтбора = КоллекцияЭлементовОтобра[0];
			ГруппаЭлементовОтбора.Элементы.Очистить();
		Иначе
			ГруппаЭлементовОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
				ОперацииРегистрация.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы,
				"ОтборПоРабочемуЦентру",
				ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		КонецЕсли;
		
		Если ОтборНаРЦ Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				ГруппаЭлементовОтбора, "РабочийЦентр", ОтборРабочийЦентр, ВидСравненияКомпоновкиДанных.Равно);
			
			ОтборПоВидуРабочегоЦентра = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
				ГруппаЭлементовОтбора,
				"ОтборПоВидуРабочегоЦентра",
				ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				ОтборПоВидуРабочегоЦентра,
				"РабочийЦентр",
				Справочники.РабочиеЦентры.ПустаяСсылка(),
				ВидСравненияКомпоновкиДанных.Равно);
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				ОтборПоВидуРабочегоЦентра,
				"ВидРабочегоЦентра",
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОтборРабочийЦентр, "ВидРабочегоЦентра"),
				ВидСравненияКомпоновкиДанных.Равно);
				
		ИначеЕсли ОтборНаВРЦ Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				ГруппаЭлементовОтбора, "ВидРабочегоЦентра", ОтборРабочийЦентр, ВидСравненияКомпоновкиДанных.Равно);
			
		КонецЕсли;
		
	ИначеЕсли КоллекцияЭлементовОтобра.Количество() > 0 Тогда
		
		КоллекцияЭлементовОтобра[0].Элементы.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСостояние()
	
	Если УправлениеМаршрутнымиЛистами = Перечисления.УправлениеМаршрутнымиЛистами.ПооперационноеПланирование Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ОперацииПланирование, 
			"Состояние", 
			ОтборСостояние.ВыгрузитьЗначения(), 
			ВидСравненияКомпоновкиДанных.ВСписке,
			, // Представление - автоматически
			ЗначениеЗаполнено(ОтборСостояние));
			
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ОперацииРегистрация, 
			"Состояние",
			ОтборСостояние.ВыгрузитьЗначения(),
			ВидСравненияКомпоновкиДанных.ВСписке,
			, // Представление - автоматически
			ЗначениеЗаполнено(ОтборСостояние));
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ВосстановитьНастройкиФормы()
	
	НастройкиФормы = ХранилищеНастроекДанныхФорм.Загрузить("ДиспетчированиеПроизводстваПооперационное", "НастройкиФормы");
	Если ЗначениеЗаполнено(НастройкиФормы) Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, НастройкиФормы);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборПодразделение) Тогда
		УправлениеМаршрутнымиЛистами = ПодразделениеМетодикаУправленияМЛ(ОтборПодразделение);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТипОтбораРабочийЦентр) Тогда
		ТипОтбораРабочийЦентр = ТипОтбораРабочийЦентрВидРабочегоЦентра();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиФормы()
	
	СтруктураНастроек = СтруктураНастроекФормы();
	ЗаполнитьЗначенияСвойств(СтруктураНастроек, ЭтаФорма);
	ХранилищеНастроекДанныхФорм.Сохранить("ДиспетчированиеПроизводстваПооперационное", "НастройкиФормы", СтруктураНастроек);
	
КонецПроцедуры

&НаСервере
Функция СтруктураНастроекФормы()
	
	Результат = Новый Структура;
	Результат.Вставить("ОтборПодразделение");
	Результат.Вставить("ОтборРабочийЦентр");
	Результат.Вставить("ОтборСостояние");
	Результат.Вставить("ТипОтбораРабочийЦентр");
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСписокОпераций()
	
	Если ПроверитьЗаполнение() Тогда
		
		Если УправлениеМаршрутнымиЛистами
			= ПредопределенноеЗначение("Перечисление.УправлениеМаршрутнымиЛистами.ПооперационноеПланирование") Тогда
			
			ОбновитьПараметрыЗапросаОперацииПланирование();
			Элементы.ОперацииПланирование.Обновить();
			
		Иначе
			
			Элементы.ОперацииРегистрация.Обновить();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтатусОпераций(НовыйСтатус)
	
	Операции = ВыделенныеОперации();
	
	Если ЗначениеЗаполнено(Операции) Тогда
		
		Если РегистрацияОпераций(ЭтотОбъект) Тогда
			
			ИзменитьСтатусОперацийНаСервере(Операции, НовыйСтатус, УправлениеМаршрутнымиЛистами);
			ОбновитьСписокОпераций();
			ОповеститьОбИзмененииСтатусаОпераций();
			
		Иначе
			
			Если ТребуетсяВыбратьОперацииССинхроннойЗагрузкой() Тогда
				
				ДополнительныеПараметры = Новый Структура("НовыйСтатус", НовыйСтатус);
				ОписаниеОповещения = Новый ОписаниеОповещения(
					"ВыборОперацийССинхроннойЗагрузкойЗавершение",
					ЭтотОбъект,
					ДополнительныеПараметры);
				
				ТекущаяСтрока = Элементы.ОперацииПланирование.ДанныеСтроки(Элементы.ОперацииПланирование.ВыделенныеСтроки[0]);
				
				ПараметрыФормы = Новый Структура;
				ПараметрыФормы.Вставить("Начало", ТекущаяСтрока.Начало);
				ПараметрыФормы.Вставить("Окончание", ТекущаяСтрока.Окончание);
				ПараметрыФормы.Вставить("РабочийЦентр", ТекущаяСтрока.РабочийЦентр);
				ПараметрыФормы.Вставить("НовыйСтатус", НовыйСтатус);
				
				ОткрытьФорму("Обработка.ВыполнениеОпераций.Форма.ВыборОперацийССинхроннойЗагрузкой",
					ПараметрыФормы,
					ЭтотОбъект,,,,
					ОписаниеОповещения,
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
			Иначе
			
				ИзменитьСтатусОперацийНаСервере(Операции, НовыйСтатус, УправлениеМаршрутнымиЛистами);
				ОбновитьСписокОпераций();
				ОповеститьОбИзмененииСтатусаОпераций();
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ПоказатьПредупреждениеНеВыбранаОперация();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборОперацийССинхроннойЗагрузкойЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатЗакрытия = Неопределено Тогда
		
		ИзменитьСтатусОперацийНаСервере(РезультатЗакрытия, ДополнительныеПараметры.НовыйСтатус, УправлениеМаршрутнымиЛистами);
		ОбновитьСписокОпераций();
		ОповеститьОбИзмененииСтатусаОпераций();
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОбИзмененииСтатусаОпераций()
	
	Оповестить(ОперативныйУчетПроизводстваКлиент.ИмяСобытияИзменениеСтатусаОпераций(),, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Функция ТребуетсяВыбратьОперацииССинхроннойЗагрузкой()
	
	ВыделенныеСтроки = Элементы.ОперацииПланирование.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 1 Тогда
		
		ТекущаяСтрока = Элементы.ОперацииПланирование.ДанныеСтроки(ВыделенныеСтроки[0]);
		Если ТекущаяСтрока.СинхроннаяЗагрузка Тогда
			Результат = МножественнаяЗагрузкаИнтервала(ТекущаяСтрока);
		Иначе
			Результат = Ложь;
		КонецЕсли;
		
	Иначе
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция МножественнаяЗагрузкаИнтервала(ТекущаяСтрока)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОперацииДляДиспетчирования.ИдентификаторОперации
	|ИЗ
	|	РегистрСведений.ОперацииДляДиспетчирования КАК ОперацииДляДиспетчирования
	|ГДЕ
	|	ОперацииДляДиспетчирования.Начало = &Начало
	|	И ОперацииДляДиспетчирования.Окончание = &Окончание
	|	И ОперацииДляДиспетчирования.РабочийЦентр = &РабочийЦентр
	|	И НЕ ОперацииДляДиспетчирования.ИдентификаторОперации = &ИдентификаторОперации");
	
	Запрос.УстановитьПараметр("Начало", ТекущаяСтрока.Начало);
	Запрос.УстановитьПараметр("Окончание", ТекущаяСтрока.Окончание);
	Запрос.УстановитьПараметр("РабочийЦентр", ТекущаяСтрока.РабочийЦентр);
	Запрос.УстановитьПараметр("ИдентификаторОперации", ТекущаяСтрока.ИдентификаторОперации);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

&НаКлиенте
Функция ВыделенныеОперации()
	
	Результат = Новый Массив;
	
	Если РегистрацияОпераций(ЭтотОбъект) Тогда
		
		Для каждого Строка Из Элементы.ОперацииРегистрация.ВыделенныеСтроки Цикл
			Результат.Добавить(Элементы.ОперацииРегистрация.ДанныеСтроки(Строка).ИдентификаторОперации);
		КонецЦикла;
		
	Иначе
		
		Для каждого Строка Из Элементы.ОперацииПланирование.ВыделенныеСтроки Цикл
			Результат.Добавить(Элементы.ОперацииПланирование.ДанныеСтроки(Строка).ИдентификаторОперации);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОтборСостояниеНачалоВыбораЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатЗакрытия = Неопределено Тогда
		
		ОтборСостояние = РезультатЗакрытия;
		ОтборСостояниеПриИзмененииНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкода)
	
	КлючТекущейСтроки = КлючСпискаОперацийПоШтрихкоду(ДанныеШтрихкода.Штрихкод);
	Если НЕ КлючТекущейСтроки = Неопределено Тогда
		Элементы.ОперацииПланирование.ТекущаяСтрока = КлючТекущейСтроки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КлючСпискаОперацийПоШтрихкоду(Штрихкод)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ПооперационноеРасписание.МаршрутныйЛист КАК Регистратор,
	|	ПооперационноеРасписание.ИдентификаторОперации
	|ИЗ
	|	РегистрСведений.ПооперационноеРасписание КАК ПооперационноеРасписание
	|ГДЕ
	|	ПооперационноеРасписание.Штрихкод = &Штрихкод");
	Запрос.УстановитьПараметр("Штрихкод", Штрихкод);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ЗначенияКлюча = Новый Структура("Регистратор, ИдентификаторОперации",
			Выборка.Регистратор, Выборка.ИдентификаторОперации);
		Результат = РегистрыСведений.ОперацииМаршрутовПроизводства.СоздатьКлючЗаписи(ЗначенияКлюча);
	
	Иначе
		
		Результат = Неопределено;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОтборПодразделениеПриИзмененииНаСервере()
	
	УправлениеМаршрутнымиЛистами = ПодразделениеМетодикаУправленияМЛ(ОтборПодразделение);
	
	Если ЗначениеЗаполнено(ОтборПодразделение) Тогда
		НастроитьФормуПоПодразделению(ЭтотОбъект);
	КонецЕсли;
	НастроитьТипЗначенияОтборРабочийЦентр(ЭтотОбъект);
	
	УстановитьОтборПодразделение();
	УстановитьОтборРабочийЦентр();
	УстановитьОтборСостояние();
	
	СохранитьНастройкиФормы();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодразделениеМетодикаУправленияМЛ(Подразделение)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Подразделение, "УправлениеМаршрутнымиЛистами");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьФормуПоПодразделению(Форма)
	
	РегистрацияОпераций = РегистрацияОпераций(Форма);
	
	Форма.Элементы.СтраницыОперации.ТекущаяСтраница = ?(
		РегистрацияОпераций,
		Форма.Элементы.СтраницаРегистрация,
		Форма.Элементы.СтарницаПланирование);
	
	Форма.Элементы.НазначитьРабочийЦентр.Видимость = РегистрацияОпераций;
	Форма.Элементы.ФормаНазначитьРабочийЦентр.Видимость = РегистрацияОпераций;
	Форма.Элементы.ОтменитьНазначениеРабочегоЦентра.Видимость = РегистрацияОпераций;
	Форма.Элементы.ФормаОтменитьНазначениеРабочегоЦентра.Видимость = РегистрацияОпераций;
	Форма.Элементы.КомандыОперацииПланирование.Видимость = НЕ РегистрацияОпераций;
	Форма.Элементы.КомандыОперацииРегистрация.Видимость = РегистрацияОпераций;
	
КонецПроцедуры

&НаСервере
Процедура ОтборРабочийЦентрПриИзмененииНаСервере()
	
	УстановитьОтборРабочийЦентр();
	СохранитьНастройкиФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОтборСостояниеПриИзмененииНаСервере()
	
	УстановитьОтборСостояние();
	СохранитьНастройкиФормы();
	
КонецПроцедуры

&НаКлиенте
Функция ДопустимоНазначениеРабочегоЦентра()
	
	Результат = Истина;
	Если НЕ Элементы.ОперацииРегистрация.ВыделенныеСтроки.Количество() = 0 Тогда
		
		ВидРабочегоЦентра = Неопределено;
		Для каждого Строка ИЗ Элементы.ОперацииРегистрация.ВыделенныеСтроки Цикл
			
			ДанныеСтроки = Элементы.ОперацииРегистрация.ДанныеСтроки(Строка);
			Если ВидРабочегоЦентра = Неопределено Тогда
				
				ВидРабочегоЦентра = ДанныеСтроки.ВидРабочегоЦентра;
				
			ИначеЕсли НЕ ВидРабочегоЦентра = ДанныеСтроки.ВидРабочегоЦентра Тогда
				
				ТекстПредупреждения = НСтр("ru='Выбраны операции с различными видами рабочих центров';uk='Вибрані операції з різними видами робочих центрів'");
				ПоказатьПредупреждение(, ТекстПредупреждения);
				Результат = Ложь;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если НЕ ЗначениеЗаполнено(ВидРабочегоЦентра) Тогда
			ТекстПредупреждения = НСтр("ru='Назначение операции на рабочий центр не требуется';uk='Призначення операції на робочий центр не вимагається'");
			ПоказатьПредупреждение(, ТекстПредупреждения);
			Результат = Ложь;
		КонецЕсли;
		
	Иначе
		
		ПоказатьПредупреждениеНеВыбранаОперация();
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ВыборРабочегоЦентраДляНазначенияЗавершение(РезультатЗакрытия, ДополнительныеПараметры)Экспорт
	
	Если НЕ РезультатЗакрытия = Неопределено Тогда
		
		НазначитьРабочийЦентрНаСервере(ВыделенныеОперации(), РезультатЗакрытия);
		ОбновитьСписокОпераций();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПредупреждениеНеВыбранаОперация()
	
	ПоказатьПредупреждение(,НСтр("ru='Необходимо выбрать операцию.';uk='Необхідно вибрати операцію.'"));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИзменитьСтатусОперацийНаСервере(Операции, НовыйСтатус, МетодикаУправления)
	
	Если МетодикаУправления = Перечисления.УправлениеМаршрутнымиЛистами.РегистрацияОпераций Тогда
		Документы.МаршрутныйЛистПроизводства.ИзменитьСтатусОпераций(Операции, НовыйСтатус);
	Иначе
		РегистрыСведений.ПооперационноеРасписание.ИзменитьСтатусОпераций(Операции, НовыйСтатус);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура НазначитьРабочийЦентрНаСервере(Операции, РабочийЦентр)
	
	Документы.МаршрутныйЛистПроизводства.НазначитьРабочийЦентрОперациям(Операции, РабочийЦентр);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РегистрацияОпераций(Форма)
	
	Возврат Форма.УправлениеМаршрутнымиЛистами
		= ПредопределенноеЗначение("Перечисление.УправлениеМаршрутнымиЛистами.РегистрацияОпераций");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьТипЗначенияОтборРабочийЦентр(Форма)
	
	Если Форма.ТипОтбораРабочийЦентр = ТипОтбораРабочийЦентрВидРабочегоЦентра() Тогда
		ДопустимыйТип = Новый ОписаниеТипов("СправочникСсылка.ВидыРабочихЦентров");
	Иначе
		ДопустимыйТип = Новый ОписаниеТипов("СправочникСсылка.РабочиеЦентры");
	КонецЕсли;
	
	Форма.ОтборРабочийЦентр = ДопустимыйТип.ПривестиЗначение(Форма.ОтборРабочийЦентр);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТипОтбораРабочийЦентрВидРабочегоЦентра()
	
	Возврат "ВидРабочегоЦентра";
	
КонецФункции

&НаКлиенте
Процедура ОткрытьМаршрутныйЛистОперации(ИмяСписка, ВыбраннаяСтрока)
	
	ДанныеСтроки = Элементы[ИмяСписка].ДанныеСтроки(ВыбраннаяСтрока);
	
	ПараметрыФормы = Новый Структура;
	Параметрыформы.Вставить("Ключ", ДанныеСтроки.МаршрутныйЛист);
	ПараметрыФормы.Вставить("КлючСвязи", ДанныеСтроки.ИдентификаторОперации);
	ОткрытьФорму("Документ.МаршрутныйЛистПроизводства.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти