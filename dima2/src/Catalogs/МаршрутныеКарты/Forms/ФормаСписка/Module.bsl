
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "НоменклатураИзделие", Справочники.Номенклатура.ПустаяСсылка());
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "НоменклатураМатериал", Справочники.Номенклатура.ПустаяСсылка());
	
	Если Параметры.Свойство("Изделие") Тогда
		// Форма открывается из карточки номенклатуры
		ОтборИзделие = Параметры.Изделие;		
		УстановитьОтборПоИзделию(ЭтаФорма);
		НеЗагружатьНастройки = Истина;
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.ОтборОтветственный.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Справочники.МаршрутныеКарты, НСтр("ru='<Мои маршрутные карты>';uk='<Мої маршрутні карти>'")));
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ОсновныеМаршрутныеКарты" Тогда
		Элементы.Список.Обновить();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если НеЗагружатьНастройки Тогда
		Настройки.Удалить("ОтборСтатус");
		Настройки.Удалить("ОтборОтветственный");
		Настройки.Удалить("ОтборПодразделение");
		Настройки.Удалить("ОтборИзделие");
		Настройки.Удалить("ОтборМатериал");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если НеЗагружатьНастройки Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьОтборПоСтатусу(ЭтаФорма);
	УстановитьОтборПоПодразделению(ЭтаФорма);
	УстановитьОтборПоИзделию(ЭтаФорма);
	УстановитьОтборПоОтветственному(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область БыстрыеОтборы

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	
	УстановитьОтборПоСтатусу(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	УстановитьОтборПоПодразделению(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборИзделиеПриИзменении(Элемент)
	
	УстановитьОтборПоИзделию(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМатериалПриИзменении(Элемент)
	
	УстановитьОтборПоМатериалу(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйПриИзменении(Элемент)
	
	УстановитьОтборПоОтветственному(ЭтаФорма);
	
КонецПроцедуры
 
#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Группа Тогда
		Возврат;
	КонецЕсли;
	
	Если Копирование Тогда
		
		Отказ = Истина;
		
		КопироватьМаршрутнуюКарту();
		
	ИначеЕсли НЕ ОтборИзделие.Пустая() Тогда
		
		Отказ = Истина;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", ОтборИзделие);
		ОткрытьФорму("Справочник.МаршрутныеКарты.ФормаОбъекта", ПараметрыФормы);
		
	КонецЕсли; 
	
КонецПроцедуры

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСтатусу(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, 
		"Статус", 
		Форма.ОтборСтатус, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборСтатус));

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоПодразделению(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, 
		"Подразделение", 
		Форма.ОтборПодразделение, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборПодразделение));

КонецПроцедуры
 
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоИзделию(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, 
		"НоменклатураИзделие", 
		Форма.ОтборИзделие, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборИзделие));
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Форма.Список, "НоменклатураИзделие", Форма.ОтборИзделие);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоМатериалу(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, 
		"НоменклатураМатериал", 
		Форма.ОтборМатериал, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборМатериал));

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Форма.Список, "НоменклатураМатериал", Форма.ОтборМатериал);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоОтветственному(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список, 
		"Ответственный", 
		Форма.ОтборОтветственный, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборОтветственный));
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьМаршрутнуюКарту()

	ТекстВопроса = НСтр("ru='Будет создана и записана копия маршрутной карты (включая техоперации).
                                |Скопировать?'
                                |;uk='Буде створена та записана копія маршрутної карти (включаючи техоперации).
                                |Скопіювати?'");
	СписокКнопок = Новый СписокЗначений;								
	СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Скопировать';uk='Скопіювати'"));
	СписокКнопок.Добавить(КодВозвратаДиалога.Отмена);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВопросКопироватьМаршрутнуюКарту", ЭтаФорма);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, СписокКнопок);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросКопироватьМаршрутнуюКарту(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Ссылка = КопироватьМаршрутнуюКартуНаСервере(ТекущиеДанные.Ссылка);
	Если Ссылка <> Неопределено Тогда
		Элементы.Список.ТекущаяСтрока = Ссылка;
		
		ОповеститьОбИзменении(Тип("СправочникСсылка.МаршрутныеКарты"));
		Оповестить("Запись_ТехнологическиеОперации");
		ОткрытьФорму("Справочник.МаршрутныеКарты.ФормаОбъекта", Новый Структура("Ключ", Ссылка));
	Иначе
		ПоказатьПредупреждение(,НСтр("ru='Не удалось скопировать маршрутную карту.';uk='Не вдалося скопіювати маршрутну карту.'"));
	КонецЕсли; 

КонецПроцедуры
 
&НаСервереБезКонтекста
Функция КопироватьМаршрутнуюКартуНаСервере(Источник)

	НачатьТранзакцию();
	
	СсылкаНового = Справочники.МаршрутныеКарты.ПолучитьСсылку();
	
	Объект = Источник.Скопировать();
	Объект.Наименование = Объект.Наименование + " " + НСтр("ru='(копия)';uk='(копія)'");
	
	Если НЕ Справочники.МаршрутныеКарты.ЗапонитьПоМаршрутнойКарте(Объект, Источник, СсылкаНового) Тогда
		
		ОтменитьТранзакцию();
		Возврат Неопределено;
		
	КонецЕсли;
	
	Попытка
		
		Объект.УстановитьСсылкуНового(СсылкаНового);
		Объект.Записать();
		
	Исключение
		
		ОтменитьТранзакцию();
		Возврат Неопределено;
		
	КонецПопытки;
	
	ЗафиксироватьТранзакцию();
	
	Возврат Объект.Ссылка;
	
КонецФункции

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаУстановитьСтатусВРазработке(Команда)
	
	УстановитьСтатус("ВРазработке", НСтр("ru='В разработке';uk='В розробці'"));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьСтатусДействует(Команда)
	
	УстановитьСтатус("Действует", НСтр("ru='Действует';uk='Діє'"));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьСтатусЗакрыта(Команда)
	
	УстановитьСтатус("Закрыта", НСтр("ru='Закрыта';uk='Закрита'"));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура УстановитьСтатус(ЗначениеСтатуса, ПредставлениеСтатуса)

	ВыделенныеСсылки = РаботаСДиалогамиКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	УправлениеДаннымиОбИзделияхКлиент.УстановитьСтатусМаршрутныхКарт(ЗначениеСтатуса, ПредставлениеСтатуса, ВыделенныеСсылки);

КонецПроцедуры

#КонецОбласти
