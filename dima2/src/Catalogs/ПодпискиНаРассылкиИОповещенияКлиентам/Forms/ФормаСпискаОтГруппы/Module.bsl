#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметры.ГруппаРассылокИОповещений) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	      ЭтотОбъект, "СписокОтправлятьПартнеру", НСтр("ru='Контрагент';uk='Контрагент'"));
	
	ГруппаРассылокИОповещений = Параметры.ГруппаРассылокИОповещений;
	РассылкиИОповещенияКлиентам.ЗаполнитьРеквизитыФормыПоГруппеРассылокИОповещений(ЭтотОбъект, ГруппаРассылокИОповещений);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
	          Список,
	          "ГруппаРассылокИОповещений",
	          ГруппаРассылокИОповещений);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Партнеры")
		И Не ВыбранноеЗначение.Пустая() Тогда
		
		РассылкиИОповещенияКлиентамКлиент.ОткрытьФормуПодписки(ВыбранноеЗначение, ГруппаРассылокИОповещений, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПодпискиНаРассылкиИОповещенияКлиентам"
		И Параметр.Свойство("ГруппаРассылокИОповещений")
		И Параметр.Подписчик = ГруппаРассылокИОповещений Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки.Получить("ПоказыватьПриостановленные") <> Неопределено Тогда
		ПоказыватьПриостановленные = Настройки.Получить("ПоказыватьПриостановленные");
		НастройкиОбработаны = Истина;
		УстановитьОтбор(ЭтотОбъект);
		Настройки.Удалить("ПоказыватьПриостановленные");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не НастройкиОбработаны Тогда
		УстановитьОтбор(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Партнеры.ФормаВыбора", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПриостановленныеПриИзменении(Элемент)
	
	УстановитьОтбор(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура Подписать(Команда)
	
	ПодписатьОтписать(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Отписать(Команда)
	
	ПодписатьОтписать(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоОтбору(Команда)
	
	ПараметрыФормы = РассылкиИОповещенияКлиентамКлиент.ПараметрыФормыПодбораПоОтбору(ЭтотОбъект);
	
	ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ПодборПартнеровПоОтборуПриЗакрытии", ЭтотОбъект);
	
	ОткрытьФорму(
		"Обработка.ПодборПартнеровПоОтбору.Форма.Форма",
		ПараметрыФормы,
		ЭтаФорма,
		УникальныйИдентификатор,
		,,
		ОбработчикОповещенияОЗакрытии);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтбор(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	      Форма.Список,
	      "ПодпискаДействует",
	      Истина,
	      ,
	      ,
	      ?(Форма.ПоказыватьПриостановленные, Ложь, Истина));

КонецПроцедуры

&НаКлиенте
Процедура ПодписатьОтписать(Подписать)
	
	ВыделенныеСтроки          = Элементы.Список.ВыделенныеСтроки;
	КоличествоСтрокКОбработке = ВыделенныеСтроки.Количество();
	МасссивПодписокКИзменению = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока);
		Если ДанныеСтроки.ПодпискаДействует <> Подписать  Тогда
			МасссивПодписокКИзменению.Добавить(ВыделеннаяСтрока);
		КонецЕсли;
		
	КонецЦикла;
	
	Если МасссивПодписокКИзменению.Количество() > 0 Тогда
		
		ОтменитьУстановитьПодпискуДляМассиваПодписок(МасссивПодписокКИзменению, Подписать);
		
		Если Подписать Тогда
			ТекстОповещения = НСтр("ru='Оформление подписки';uk='Оформлення підписки'");
		Иначе
			ТекстОповещения = НСтр("ru='Отмена подписки';uk='Скасування підписки'");
		КонецЕсли;
		
		ТекстПояснения = НСтр("ru='Подписка %1 для %2 из %3 партнеров.';uk='Підписка %1 для %2 з %3 партнерів.'");
		ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		               ТекстПояснения,
		               ?(Подписать, НСтр("ru='выполнена';uk='виконано'"), НСтр("ru='отменена';uk='скасовано'")),
		               МасссивПодписокКИзменению.Количество(),
		               КоличествоСтрокКОбработке);
		
	Иначе
		
		ТекстОповещения = НСтр("ru='Изменение подписок не выполнено';uk='Зміна підписок не виконана'");
		ТекстПояснения  = НСтр("ru='Нет партнеров, для которых необходимо изменить подписку.';uk='Немає партнерів, для яких необхідно змінити підписку.'");
		
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ТекстОповещения, , ТекстПояснения);
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьУстановитьПодпискуДляМассиваПодписок(МасссивПодписок, Подписать)

	Если Подписать Тогда
		Справочники.ПодпискиНаРассылкиИОповещенияКлиентам.ОформитьПодпискуДляМассиваСуществующихИНовыхПодписок(МасссивПодписок);
	Иначе
		Справочники.ПодпискиНаРассылкиИОповещенияКлиентам.ОтменитьПодпискуДляМассива(МасссивПодписок);
	КонецЕсли;
	
	Элементы.Список.Обновить();

КонецПроцедуры

&НаСервере
Процедура ДобавитьПартнеровПоОтборуНаСервере(АдресВоВременномХранилище)

	РассылкиИОповещенияКлиентам.ДобавитьПодписчиковПоОтбору(АдресВоВременномХранилище, ГруппаРассылокИОповещений,
	                                                        ПредназначенаДляSMS, ПредназначенаДляЭлектронныхПисем);
	Элементы.Список.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ПодборПартнеровПоОтборуПриЗакрытии(АдресВоВременномХранилище, ДополнительныеПараметры) Экспорт

	Если ЗначениеЗаполнено(АдресВоВременномХранилище) Тогда
		ДобавитьПартнеровПоОтборуНаСервере(АдресВоВременномХранилище);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

