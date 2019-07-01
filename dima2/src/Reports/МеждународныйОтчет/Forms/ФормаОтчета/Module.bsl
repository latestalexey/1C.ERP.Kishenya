&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Отчет доступен только для контекстного вызова
	Если НЕ Параметры.Свойство("СформироватьОтчет") Тогда
		Отказ = Истина;
		ВызватьИсключение НСтр("ru='Отчет не предназначен для ручного запуска.';uk='Звіт не призначений для ручного запуску.'");
		Возврат;
	КонецЕсли;
	
	Ресурс = "Сумма";
	Если Параметры.Свойство("Отбор") Тогда
		
		ЗаполнитьЗначенияСвойств(Отчет, Параметры.Отбор);
		ИнициализироватьВидОтчета();
		
	КонецЕсли;
	
	Если Параметры.Свойство("АдресХранилища") Тогда
		
		АдресХранилища = Параметры.АдресХранилища;
		ЗагрузитьПодготовленныеДанные();
		
	КонецЕсли;
	
	Если Параметры.СформироватьОтчет Тогда
		
		СформироватьОтчет = Параметры.СформироватьОтчет;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ПараметрыРасшифровки") Тогда
		ПараметрыРасшифровки = Параметры.ПараметрыРасшифровки;
		ЗаполнитьЗначенияСвойств(Отчет, ПараметрыРасшифровки);
		ЗаполнитьЗначенияСвойств(Отчет, ПараметрыРасшифровки.Отбор);
		Если ПараметрыРасшифровки.Отбор.Свойство("Организация") И ЗначениеЗаполнено(ПараметрыРасшифровки.Отбор.Организация) Тогда
			ИспользоватьОтборПоОрганизациям = Истина;
			Организации.ЗагрузитьЗначения(ПараметрыРасшифровки.Отбор.Организация);
		КонецЕсли;
		Если ПараметрыРасшифровки.Отбор.Свойство("Подразделение") И ЗначениеЗаполнено(ПараметрыРасшифровки.Отбор.Подразделение) Тогда
			ИспользоватьОтборПоПодразделениям = Истина;
			Подразделения.ЗагрузитьЗначения(ПараметрыРасшифровки.Отбор.Подразделение);
		КонецЕсли;
		Отчет.НачалоПериода = ПараметрыРасшифровки.ПериодОтчета.ДатаНачала;
		Отчет.КонецПериода = ПараметрыРасшифровки.ПериодОтчета.ДатаОкончания;
		Ресурс = ПараметрыРасшифровки.Ресурс;
		ДанныеПоказателя = ПоместитьВоВременноеХранилище(ПараметрыРасшифровки.Показатель, УникальныйИдентификатор);
		ПроизводныйПоказатель = ПараметрыРасшифровки.Показатель.Ссылка;
		Заголовок = НСтр("ru='Расшифровка показателя:';uk='Розшифровка показника:'")+ " " + ПроизводныйПоказатель.НаименованиеДляПечати;
		Элементы.ГруппаАвтоСумма.Видимость = Ложь;
		Элементы.ГруппаДополнительнаяКоманднаяПанель.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если НЕ ЗначениеЗаполнено(ПроизводныйПоказатель) Тогда
		ОбновитьТекстЗаголовка(ЭтаФорма);
	КонецЕсли;
	
	ИБФайловая = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	Если ПодключитьОбработчикОжидания Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПроизводныйПоказатель) Тогда
		УстановитьВидимостьПанелиНастроек(Ложь);
	КонецЕсли;
	
	Если СформироватьОтчет Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
		ПодключитьОбработчикОжидания("СформироватьНепосредственно", 0.1, Истина);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресХранилища) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	КонецЕсли;
	Элементы.ПанельНастроек.Пометка = Элементы.ГруппаПанельНастроек.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	ВариантМодифицирован                    = Ложь;
	ПользовательскиеНастройкиМодифицированы = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()

	ОтменитьВыполнениеЗадания();

КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)

	ДанныеОтчета = Новый Структура;
	ДанныеОтчета.Вставить("ВидОтчета", Отчет.ВидОтчета);
	ДанныеОтчета.Вставить("НачалоПериода", Отчет.НачалоПериода);
	ДанныеОтчета.Вставить("КонецПериода", Отчет.КонецПериода);
	ДанныеОтчета.Вставить("СуммыВТысячах", Отчет.СуммыВТысячах);
	ДанныеОтчета.Вставить("СкрыватьНастройкиПриФормированииОтчета", СкрыватьНастройкиПриФормированииОтчета);
	ДанныеОтчета.Вставить("Организации", Организации.ВыгрузитьЗначения());
	ДанныеОтчета.Вставить("Подразделения", Подразделения.ВыгрузитьЗначения());
	
	Настройки.ДополнительныеСвойства.Вставить("ДанныеОтчета", ДанныеОтчета);

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)

	ВидОтчета = Отчет.ВидОтчета;
	КомплектОтчетности = Отчет.КомплектОтчетности;
	
	Если НЕ Параметры.Свойство("ПараметрыРасшифровки") Тогда
		Если Настройки <> Неопределено И Настройки.ДополнительныеСвойства.Свойство("ДанныеОтчета") Тогда
			ДанныеОтчета = Настройки.ДополнительныеСвойства.ДанныеОтчета;
			Если ТипЗнч(ДанныеОтчета) = Тип("Структура") Тогда
				ЗаполнитьЗначенияСвойств(ЭтаФорма, ДанныеОтчета);
				ЗаполнитьЗначенияСвойств(Отчет, ДанныеОтчета);
				Организации.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации");
				Организации.ЗагрузитьЗначения(ДанныеОтчета.Организации);
				Подразделения.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия");
				Подразделения.ЗагрузитьЗначения(ДанныеОтчета.Подразделения);
				ИспользоватьОтборПоОрганизациям = Организации.Количество();
				ИспользоватьОтборПоПодразделениям = Подразделения.Количество();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Элементы.ПанельНастроек.Заголовок = НСтр("ru='Быстрые настройки';uk='Швидкі настройки'");
	
	Если ЗначениеЗаполнено(ВидОтчета) Тогда
		Отчет.ВидОтчета = ВидОтчета;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КомплектОтчетности) Тогда
		Отчет.КомплектОтчетности = КомплектОтчетности;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ПараметрыРасшифровки") Тогда
		ОбновитьТекстЗаголовка(ЭтаФорма);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)

	СформироватьНепосредственно();

КонецПроцедуры

&НаКлиенте
Процедура ПанельНастроек(Команда)

	УстановитьВидимостьПанелиНастроек(Не Элементы.ГруппаПанельНастроек.Видимость);

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	НаименованиеВидаОтчета = Строка(Отчет.ВидОтчета);
	ОтображениеСостояния = Элементы.Результат.ОтображениеСостояния;
	Если ОтображениеСостояния.Видимость = Истина
		И ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность Тогда
		
		ТекстВопроса = НСтр("ru='Отчет не сформирован. Сформировать?';uk='Звіт не сформований. Сформувати?'");
		Ответ = Неопределено;

		ПоказатьВопрос(Новый ОписаниеОповещения("ОтправитьПоЭлектроннойПочтеЗавершение", ЭтотОбъект, Новый Структура("НаименованиеВидаОтчета", НаименованиеВидаОтчета)), ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
        Возврат;
	КонецЕсли;
	
	ОтправитьПоЭлектроннойПочтеФрагмент(НаименованиеВидаОтчета);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочтеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    НаименованиеВидаОтчета = ДополнительныеПараметры.НаименованиеВидаОтчета;
    
    
    Ответ = РезультатВопроса;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
    
    СформироватьНепосредственно();
    
    ОтправитьПоЭлектроннойПочтеФрагмент(НаименованиеВидаОтчета);

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочтеФрагмент(Знач НаименованиеВидаОтчета)
    
    Перем ПараметрыФормы, ТабличныеДокументы;
    
    ТабличныеДокументы = Новый СписокЗначений;
    ТабличныеДокументы.Добавить(ЭтаФорма.Результат, НаименованиеВидаОтчета);
    
    ПараметрыФормы = Новый Структура;
    ПараметрыФормы.Вставить("ТабличныеДокументы", ТабличныеДокументы);
    ПараметрыФормы.Вставить("Тема", НаименованиеВидаОтчета);
    ПараметрыФормы.Вставить("Заголовок", СтрЗаменить(
    НСтр("ru='Отправка отчета ""%1"" по почте';uk='Відправлення звіту ""%1"" поштою'"),
    "%1",
    НаименованиеВидаОтчета));
    
    ОткрытьФорму("ОбщаяФорма.ОтправкаТабличныхДокументовПоПочте", ПараметрыФормы, , );

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)

	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Отчет.НачалоПериода, Отчет.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомплектОтчетностиПриИзменении(Элемент)
	
	КомплектОтчетностиПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура КомплектОтчетностиПриИзмененииСервер()
	
	СписокОтчетов = Элементы.ВидОтчета.СписокВыбора;
	Для Каждого ОтчетКомплекта Из Отчет.КомплектОтчетности.ВидыОтчетов Цикл
		СписокОтчетов.Добавить(ОтчетКомплекта.ВидФинансовогоОтчета);
	КонецЦикла;
	
	Если СписокОтчетов.Количество() > 0 Тогда
		Отчет.ВидОтчета = СписокОтчетов[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрОтчетаПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	МеждународнаяОтчетностьКлиент.ОбработкаРасшифровкиОтчета(ЭтаФорма, Элемент, Расшифровка);

КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)

	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьНепосредственно()
	
	ОчиститьСообщения();
	
	РезультатВыполнения = СформироватьОтчетСервер();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьПанелиНастроек(Показать)
	
	Элементы.ГруппаПанельНастроек.Видимость = Показать;
	Элементы.ПанельНастроек.Пометка = Элементы.ГруппаПанельНастроек.Видимость;
	
КонецПроцедуры

&НаСервере
Функция ВалютыСовпадают()
	
	ВалютыСовпадают = Истина;
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаМУ = МеждународнаяОтчетностьВызовСервера.УчетнаяВалюта();
	
	Валюты = Новый Структура;
	Валюты.Вставить("Регл",ВалютаРегл);
	Валюты.Вставить("Регл",ВалютаРегл);
	Валюты.Вставить("Функциональная",ВалютаМУ.Функциональная);
	Валюты.Вставить("Представления",ВалютаМУ.Представления);
	
	Если ВидПоказателей = Перечисления.ВидыПоказателейОтчетности.МеждународныеИРегламентированные
		И ВалютаРегл <> ВалютаМУ.Функциональная И ВалютаРегл <> ВалютаМУ.Представления Тогда
		ВалютыСовпадают = Ложь;
		Шаблон = НСтр("ru='Валюта регл. учета %1; Функциональная валюта %2; Валюта представления %3.
                            |Формирование отчета возможно только при совпадении 
                            |валюты регламентированного учета с одной из валют международного учета.'
                            |;uk='Валюта регл. обліку %1; Функціональна валюта %2; Валюта представлення %3.
                            |Формування звіту можливо лише при співпаданні 
                            |валюти регламентованого обліку з однієї з валют міжнародного обліку.'");
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, 
																		ВалютаРегл, 
																		ВалютаМУ.Функциональная,  
																		ВалютаМУ.Представления);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
	КонецЕсли;
	
	Возврат ВалютыСовпадают;
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыОтчета()

	ОтборОтчета = Новый Структура;
	Если ИспользоватьОтборПоОрганизациям Тогда
		ОтборОтчета.Вставить("Организация", Организации.ВыгрузитьЗначения());
	КонецЕсли;
	Если ИспользоватьОтборПоПодразделениям Тогда
		ОтборОтчета.Вставить("Подразделение", Подразделения.ВыгрузитьЗначения());
	КонецЕсли;
	
	Реквизиты = ОбщегоНазначенияУТВызовСервера.ЗначенияРеквизитовОбъекта(Отчет.ВидОтчета, "ВыводитьКодСтроки,ВыводитьПримечание");
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ВыводитьКодСтроки"  , Реквизиты.ВыводитьКодСтроки);
	ПараметрыОтчета.Вставить("ВыводитьПримечание" , Реквизиты.ВыводитьПримечание);
	ПараметрыОтчета.Вставить("ПериодОтчета"       , МеждународнаяОтчетностьСервер.ПериодОтчета(Отчет.НачалоПериода, КонецДня(Отчет.КонецПериода)));
	ПараметрыОтчета.Вставить("Отбор"              , ОтборОтчета);
	ПараметрыОтчета.Вставить("КомплектОтчетности" , Отчет.КомплектОтчетности);
	ПараметрыОтчета.Вставить("ВидОтчета"          , Отчет.ВидОтчета);
	ПараметрыОтчета.Вставить("Ресурс"             , Ресурс);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"  , ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор));
	ПараметрыОтчета.Вставить("ИдентификаторФормыОтчета", УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("СуммыВТысячах"      , Отчет.СуммыВТысячах);
	Если НЕ ПроизводныйПоказатель.Пустая() Тогда
		Показатель = ПолучитьИзВременногоХранилища(ДанныеПоказателя);
		ПараметрыОтчета.Вставить("ДанныеПоказателя", Показатель);
		ПараметрыОтчета.Вставить("АдресДанныхПоказателя", ДанныеПоказателя);
	КонецЕсли;
	
	Возврат ПараметрыОтчета;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)

	Отчет = Форма.Отчет;
	Если Не ЗначениеЗаполнено(Отчет.НачалоПериода) Тогда
		Отчет.НачалоПериода = НачалоГода(ТекущаяДата());
		Отчет.КонецПериода = КонецГода(ТекущаяДата());
	КонецЕсли;
	
	ЗаголовокОтчета = НСтр("ru='Международный отчет';uk='Міжнародний звіт'");
	Если ЗначениеЗаполнено(Отчет.ВидОтчета) Тогда
		ЗаголовокОтчета = Строка(Отчет.ВидОтчета);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отчет.Организация) Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + БухгалтерскиеОтчетыВызовСервераПовтИсп.ПолучитьТекстОрганизация(Отчет.Организация);
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаСервере
Функция СформироватьОтчетСервер() Экспорт

	Если Не ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;

	Если НЕ ВалютыСовпадают() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();

	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);

	ИдентификаторЗадания = Неопределено;

	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);

	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		МеждународнаяОтчетностьСервер.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		ИмяПроцедуры = "МеждународнаяОтчетностьСервер.СформироватьОтчет";
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			ИмяПроцедуры,
			ПараметрыОтчета,
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));

		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;

	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные(ИБФайловая);
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.СкрыватьНастройкиПриФормированииОтчета(ЭтаФорма);
	
	Возврат РезультатВыполнения;

КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные(ИБФайловая = Неопределено)

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат = РезультатВыполнения.Результат;

	Если ИБФайловая = Неопределено Тогда
		ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	КонецЕсли;
	Если НЕ ИБФайловая И РезультатВыполнения.Свойство("СообщенияОбОшибках") Тогда
		Для Каждого Сообщение Из РезультатВыполнения.СообщенияОбОшибках Цикл
			Сообщение.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	ИдентификаторЗадания = Неопределено;

	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	Если НЕ ЗначениеЗаполнено(Отчет.ВидОтчета) Тогда
		ЗаполнитьЗначенияСвойств(Отчет, РезультатВыполнения);
		ИнициализироватьВидОтчета();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()

	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал,
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьВидОтчета()
	
	Реквизиты = ОбщегоНазначенияУТВызовСервера.ЗначенияРеквизитовОбъекта(Отчет.ВидОтчета,"ВидПоказателей");
	
	ВидПоказателей = Реквизиты.ВидПоказателей;
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаМУ = МеждународнаяОтчетностьВызовСервера.УчетнаяВалюта();
	СписокВыбора = Элементы.Ресурс.СписокВыбора;
	СписокВыбора.Очистить();
	СписокВыбора.Добавить("Сумма",Строка(ВалютаМУ.Функциональная)+НСтр("ru=' (функциональная валюта)';uk=' (функціональна валюта)'"));
	СписокВыбора.Добавить("СуммаПредставления",Строка(ВалютаМУ.Представления)+НСтр("ru=' (валюта представления)';uk=' (валюта подання)'"));
	
	Если ВидПоказателей = Перечисления.ВидыПоказателейОтчетности.Регламентированные Тогда
		Элементы.Ресурс.Видимость = Ложь;
	ИначеЕсли ВидПоказателей = Перечисления.ВидыПоказателейОтчетности.МеждународныеИРегламентированные Тогда
		Элементы.Ресурс.Видимость = Истина;
		Элементы.Ресурс.ТолькоПросмотр = Истина;
		Если ВалютаРегл = ВалютаМУ.Представления Тогда
			Ресурс = "СуммаПредставления";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

#КонецОбласти
