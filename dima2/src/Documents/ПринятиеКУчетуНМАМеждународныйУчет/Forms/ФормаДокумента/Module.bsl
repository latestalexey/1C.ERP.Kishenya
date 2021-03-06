
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НематериальныйАктивПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.НематериальныйАктив) Тогда
		НематериальныйАктивПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НематериальныйАктивПриИзмененииНаСервере()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	НематериальныеАктивы.ГруппаНМАМеждународныйУчет.ПорядокУчета КАК ПорядокУчета
		|ИЗ
		|	Справочник.НематериальныеАктивы КАК НематериальныеАктивы
		|ГДЕ
		|	НематериальныеАктивы.Ссылка = &Ссылка"
	);
	
	Запрос.УстановитьПараметр("Ссылка", Объект.НематериальныйАктив);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Объект.ПорядокУчета = Выборка.ПорядокУчета;
		ОбновитьДоступностьЭлементовФормы("ПорядокУчета");
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПорядокУчетаПриИзменении(Элемент)
	ОбновитьДоступностьЭлементовФормы("ПорядокУчета");
КонецПроцедуры

&НаКлиенте
Процедура МетодНачисленияАмортизацииПриИзменении(Элемент)
	ОбновитьДоступностьЭлементовФормы("МетодНачисленияАмортизации");
КонецПроцедуры

&НаКлиенте
Процедура ПервоначальнаяСтоимостьПриИзменении(Элемент)
	
	Объект.ПервоначальнаяСтоимостьПредставления = Объект.ПервоначальнаяСтоимость * КоэффициентПересчетаВВалютуПредставления;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛиквидационнаяСтоимостьПриИзменении(Элемент)
	
	Объект.ЛиквидационнаяСтоимостьПредставления = Объект.ЛиквидационнаяСтоимость * КоэффициентПересчетаВВалютуПредставления;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СтатьяРасходов) Тогда
		СтатьяРасходовПриИзмененииНаСервере();
	Иначе
		АналитикаРасходовОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииНаСервере()
	
	АналитикаРасходовОбязательна = 
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
	
КонецПроцедуры

&НаКлиенте
Процедура СчетРасходовПриИзменении(Элемент)
	ОбновитьДоступностьЭлементовФормы("СчетРасходов");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты


&НаКлиенте
Процедура ЗаполнитьПервоначальнуюСтоимость(Команда)
	ЗаполнитьПервоначальнуюСтоимостьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПервоначальнуюСтоимостьНаСервере()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СУММА(МеждународныйОстаткиИОбороты.СуммаНачальныйОстатокДт + МеждународныйОстаткиИОбороты.СуммаОборотДт) КАК ПервоначальнаяСтоимость,
		|	СУММА(МеждународныйОстаткиИОбороты.СуммаПредставленияНачальныйОстатокДт + МеждународныйОстаткиИОбороты.СуммаПредставленияОборотДт) КАК ПервоначальнаяСтоимостьПредставления
		|ИЗ
		|	РегистрБухгалтерии.Международный.ОстаткиИОбороты(
		|			&МесяцНачало,
		|			&МесяцОкончание,
		|			,
		|			,
		|			Счет = &Счет,
		|			,
		|			Организация = &Организация
		|				И Подразделение = &Подразделение
		|				И Субконто1 = &НематериальныйАктив) КАК МеждународныйОстаткиИОбороты");
	
	Запрос.УстановитьПараметр("Счет", Объект.СчетКапитальныхВложений);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("МесяцНачало", НачалоМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("МесяцОкончание", Новый Граница(КонецМесяца(Объект.Дата), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("НематериальныйАктив", Объект.НематериальныйАктив);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Объект.ПервоначальнаяСтоимость = 0;
		Объект.ПервоначальнаяСтоимостьПредставления = 0;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Объект.ПервоначальнаяСтоимость = Выборка.ПервоначальнаяСтоимость;
		Объект.ПервоначальнаяСтоимостьПредставления = Выборка.ПервоначальнаяСтоимостьПредставления;
	КонецЕсли;
	
КонецПроцедуры

#Область СтандартныеПодсистемы_ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если Не ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	ВалютаФункциональная = Константы.ВалютаФункциональная.Получить();
	ВалютаПредставления = Константы.ВалютаПредставления.Получить();
	
	ШаблонДекорацииВалюты = НСтр("ru='(%Валюта%)';uk='(%Валюта%)'");
	ДекорацияВалютаФункциональная = СтрЗаменить(ШаблонДекорацииВалюты, "%Валюта%", ВалютаФункциональная);
	ДекорацияВалютаПредставления = СтрЗаменить(ШаблонДекорацииВалюты, "%Валюта%", ВалютаПредставления);
	
	КоэффициентПересчетаВВалютуПредставления = РаботаСКурсамивалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(
		ВалютаФункциональная,
		ВалютаПредставления,
		?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()));
	
	ОбновитьДоступностьЭлементовФормы();
	
	АналитикаРасходовОбязательна = 
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступностьЭлементовФормы(ИзмененныеРеквизиты=Неопределено)
	
	ОбновитьВсе = (ИзмененныеРеквизиты=Неопределено);
	Реквизиты = Новый Структура(ИзмененныеРеквизиты);
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ПорядокУчета") Тогда
		
		НачислятьАмортизацию = (Объект.ПорядокУчета=Перечисления.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию);
		Списывать = (Объект.ПорядокУчета=Перечисления.ПорядокУчетаСтоимостиВнеоборотныхАктивов.СписыватьПриПринятииКУчету);
		
		Элементы.ГруппаСчетАмортизации.Видимость = НачислятьАмортизацию;
		Элементы.ГруппаАмортизация.Видимость = НачислятьАмортизацию;
		Элементы.ГруппаСчетРасходов.Видимость = Списывать;
		Элементы.ГруппаСубконтоСчетаРасходов.Видимость = Списывать;
		
		Если Списывать Тогда
			Реквизиты.Вставить("СчетРасходов");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("МетодНачисленияАмортизации") Тогда
		
		АмортизацияПоОбъемуПродукции = (Объект.МетодНачисленияАмортизации=Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции);
		Элементы.СрокИспользования.АвтоОтметкаНезаполненного = Не АмортизацияПоОбъемуПродукции;
		Элементы.СрокИспользования.ОтметкаНезаполненного = Не АмортизацияПоОбъемуПродукции;
		Элементы.ОбъемНаработки.Видимость = АмортизацияПоОбъемуПродукции;
		Элементы.КоэффициентУскорения.Видимость = (Объект.МетодНачисленияАмортизации=Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка)
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("СчетРасходов") Тогда
		
		Если ЗначениеЗаполнено(Объект.СчетРасходов) Тогда
			Элементы.ГруппаСубконтоСчетаРасходов.Видимость = Истина;
			ОбновитьЗаголовкиСубконтоСчетаРасходов();
		Иначе
			Элементы.ГруппаСубконтоСчетаРасходов.Видимость = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовкиСубконтоСчетаРасходов()
	
	Элементы.СчетРасходовСубконто1.Видимость = Ложь;
	Элементы.СчетРасходовСубконто2.Видимость = Ложь;
	Элементы.СчетРасходовСубконто3.Видимость = Ложь;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 3
		|	СубконтоСчета.ВидСубконто.Наименование КАК Заголовок,
		|	СубконтоСчета.ВидСубконто.ТипЗначения КАК ТипЗначения
		|ИЗ
		|	ПланСчетов.Международный.ВидыСубконто КАК СубконтоСчета
		|ГДЕ
		|	СубконтоСчета.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	СубконтоСчета.НомерСтроки"
	);
	Запрос.УстановитьПараметр("Ссылка", Объект.СчетРасходов);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Индекс = 1;
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Элементы["СчетРасходовСубконто"+Формат(Индекс, "ЧГ=0")].Заголовок = "   " + Выборка.Заголовок;
		Элементы["СчетРасходовСубконто"+Формат(Индекс, "ЧГ=0")].ОграничениеТипа = Выборка.ТипЗначения;
		Элементы["СчетРасходовСубконто"+Формат(Индекс, "ЧГ=0")].Видимость = Истина;
		Индекс = Индекс + 1;
	КонецЦикла;
	
КонецПроцедуры

#Область СтандартныеПодсистемы_ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти