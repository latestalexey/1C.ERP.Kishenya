
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Заголовок = Документы.ВводОстатковВнеоборотныхАктивов.ПредставлениеДокумента(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ТипОперации", Объект.ТипОперации);
	Оповестить("Запись_ВводОстатковВнеоборотныхАктивов", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИзменениеСтрокиОС();
	
КонецПроцедуры

&НаКлиенте
Процедура ОСПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ИзменениеСтрокиОС(Истина, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ОСПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ИзменениеСтрокиОС();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СтандартныеПодсистемы

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	Заголовок = Документы.ВводОстатковВнеоборотныхАктивов.ПредставлениеДокумента(Объект);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтруктуруТабличнойЧастиОС()
	
	СтрокаТаблицы = Элементы.ОС.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат Новый Структура;
	КонецЕсли;
	
	СтруктураТабличнойЧастиОС = Новый Структура(
	"ОсновноеСредство,
	|ИнвентарныйНомер,
	|СчетУчета,
	|СчетАмортизации,
	|МОЛ,
	|АдресМестонахождения,
	|ПервоначальнаяСтоимостьБУ,
	|ПервоначальнаяСтоимостьНУ,
	|ТекущаяСтоимостьБУ,
	|ТекущаяСтоимостьНУ,
	|НакопленнаяАмортизацияБУ,
	|НакопленнаяАмортизацияНУ,
	|НачислятьАмортизациюБУ,
	|МетодНачисленияАмортизацииБУ,
	|СпособНачисленияАмортизацииНУ,
	|СчетУчетаДооценокОС,
	|НалоговаяГруппаОС,
	|НалоговоеНазначение,
	|ЛиквидационнаяСтоимостьБУ,
	|СуммаПоследнейМодернизацииБУ,
	|ПревышениеСуммДооценокНадСуммамиУценокБУ,
	|СуммаДопКапиталаНачисленногоПриДооценкахОСБУ,
	|СрокИспользованияБУ,
	|ПоказательНаработки,
	|ОбъемНаработкиБУ,
	|ГрафикАмортизацииБУ,
	|НачислятьАмортизациюНУ,
	|СрокИспользованияНУ,
	|СтатьяРасходовАмортизации,
	|АналитикаРасходовАмортизации,
	|НомерДокументаПринятияКУчету,
	|НомерДокументаМодернизации,
	|СобытиеПринятияКУчету,
	|СобытиеМодернизации,
	|НазваниеДокументаПринятияКУчету,
	|НазваниеДокументаМодернизации,
	|ДатаПринятияКУчету,
	|ДатаМодернизации,
	|Контрагент,
	|ПередаватьРасходыВДругуюОрганизацию,
	|ОрганизацияПолучательРасходов,
	|СчетПередачиРасходов,
	|ЕстьСобытияМодернизации,
	|СтоимостьДляВычисленияАмортизации,
	|ПервоначальнаяСтоимостьОтличается");
	
	ЗаполнитьЗначенияСвойств(СтруктураТабличнойЧастиОС, СтрокаТаблицы);
	
	Возврат СтруктураТабличнойЧастиОС;
	
КонецФункции

&НаКлиенте
Процедура ИзменениеСтрокиОС(ЭтоНовый = Ложь, Копирование = Ложь)
	
	ДанныеЗаполнения = ?(Не ЭтоНовый ИЛИ Копирование, ПолучитьСтруктуруТабличнойЧастиОС(), Новый Структура);
	ДанныеЗаполнения.Вставить("Дата", Объект.Дата);
	ДанныеЗаполнения.Вставить("Организация", Объект.Организация);
	ДанныеЗаполнения.Вставить("ТипОперации", Объект.ТипОперации);
	ДанныеЗаполнения.Вставить("Ссылка", Объект.Ссылка);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЭтоНовый", ЭтоНовый);
	СтруктураПараметров.Вставить("Копирование", Копирование);
	СтруктураПараметров.Вставить("ДанныеЗаполнения", ДанныеЗаполнения);
	
	ФормаРедактированияСтроки = Неопределено;
	
	ОткрытьФорму(
		"Документ.ВводОстатковВнеоборотныхАктивов.Форма.ФормаРедактированияСтрокиОС",
		СтруктураПараметров,
		ЭтаФорма,,,,
		Новый ОписаниеОповещения(
			"ИзменениеСтрокиОСЗавершение",
			ЭтотОбъект,
			Новый Структура("ЭтоНовый", ЭтоНовый)),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеСтрокиОСЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ЭтоНовый = ДополнительныеПараметры.ЭтоНовый;
    
    
    ФормаРедактированияСтроки = Результат;
    
    Если ФормаРедактированияСтроки = Неопределено Тогда
        Возврат;
    КонецЕсли;
    
    Если ЭтоНовый Тогда
        СтрокаТаблицы = Объект.ОС.Добавить();
    Иначе
        СтрокаТаблицы = Объект.ОС.НайтиПоИдентификатору(Элементы.ОС.ТекущаяСтрока);
    КонецЕсли;
    
    ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ФормаРедактированияСтроки);
    
    Модифицированность = Истина;

КонецПроцедуры


#КонецОбласти
