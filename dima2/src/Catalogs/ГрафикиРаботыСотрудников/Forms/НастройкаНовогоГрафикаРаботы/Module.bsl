
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПараметрыВДанныеФормы();
	
	УстановитьНастройкиТаблицыРасписаниеРаботы();
	
	ОписаниеИспользуемыхВидовВремени = СписокВидовВремени.НайтиСтроки(Новый Структура("Использовать", Истина));

	ДобавитьКолонкиВидовВремени(ОписаниеИспользуемыхВидовВремени);
	
	ЗаполнитьРасписаниеРаботыИзНастроек(Параметры.ЧасыПоДнямЦикла);
		
	НастроитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидГрафикаПриИзменении(Элемент)
	ВидГрафикаПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НеполноеРабочееВремяПриИзменении(Элемент)
	НастроитьДоступностьЭлементов(ЭтаФорма);
	УстановитьПереключательНеполногоРабочегоВремени(ЭтаФорма);	
	Если Не НеполноеРабочееВремя Тогда
		СчитатьНормуПоДругомуГрафику = Ложь;
		ГрафикПолногоВремени = ПредопределенноеЗначение("Справочник.ГрафикиРаботыСотрудников.ПустаяСсылка");
	КонецЕсли;	
	
	ЗаполнитьСписокВидовВремени();
КонецПроцедуры

&НаКлиенте
Процедура СчитатьНормуПоДругомуГрафикуПриИзменении(Элемент)
	НастроитьДоступностьЭлементов(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура НеполноеРабочееВремяПереключательПриИзменении(Элемент)
	НеполныйРабочийДень = Ложь;
	СокращеннаяРабочаяНеделя = Ложь;
	Если НеполноеРабочееВремяПереключатель = 1 Тогда
		НеполныйРабочийДень = Истина;
	ИначеЕсли НеполноеРабочееВремяПереключатель = 2 Тогда
		СокращеннаяРабочаяНеделя = Истина;
	Иначе
		СокращеннаяРабочаяНеделя = Ложь;
		НеполныйРабочийДень = Ложь;
	КонецЕсли;	
				
КонецПроцедуры

&НаКлиенте
Процедура СуммированныйУчетРабочегоВремениПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовСуммированногоУчета(ЭтаФорма);
	
	Если НЕ СуммированныйУчетРабочегоВремени Тогда
		СпособОпределенияНормыСуммированногоУчета = ПредопределенноеЗначение("Перечисление.СпособыОпределенияНормыСуммированногоУчета.ПустаяСсылка");
		ГрафикНормыПриСуммированномУчете = ПредопределенноеЗначение("Справочник.ГрафикиРаботыСотрудников.ПустаяСсылка");
	Иначе
		СпособОпределенияНормыСуммированногоУчета = ПредопределенноеЗначение("Перечисление.СпособыОпределенияНормыСуммированногоУчета.ПоПроизводственномуКалендарю");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОпределенияНормыСуммированногоУчетаПриИзменении(Элемент)
	УстановитьДоступностьГрафикаНормыПриСуммированномУчете(ЭтаФорма);
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыФормыСписокВидовВремени

&НаКлиенте
Процедура СписокВидовВремениИспользоватьПриИзменении(Элемент)
	ИспользованиеВидаВремениПриИзмененииНаСервере(Элементы.СписокВидовВремени.ТекущаяСтрока);	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыРасписаниеРаботы

&НаКлиенте
Процедура РасписаниеРаботыДеньПриИзменении(Элемент)
	ДанныеТекущейСтроки = Элементы.РасписаниеРаботы.ТекущиеДанные;
	ДанныеТекущейСтроки.НомерДняПредставление = ПредставленияДняЦикла(ДанныеТекущейСтроки.НомерДняЦикла, СпособЗаполнения);	
КонецПроцедуры

&НаКлиенте
Процедура РасписаниеРаботыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		ДанныеТекущейСтроки = Элементы.РасписаниеРаботы.ТекущиеДанные;
		ДанныеТекущейСтроки.НомерДняЦикла = РасписаниеРаботы.Количество();
		ДанныеТекущейСтроки.НомерДняПредставление = ПредставленияДняЦикла(ДанныеТекущейСтроки.НомерДняЦикла, СпособЗаполнения)
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура РасписаниеРаботыПриИзменении(Элемент)
	ЭтоНедельныйГрафик = СпособЗаполнения = ПредопределенноеЗначение("Перечисление.СпособыЗаполненияГрафикаРаботы.ПоНеделям");
	
	НомерДня = 0;
	
	Если ЭтоНедельныйГрафик Тогда
		ДлительностьРабочейНедели = 0;
	КонецЕсли;	
	
	Для Каждого СтрокаРасписания Из РасписаниеРаботы Цикл
		НомерДня = НомерДня + 1;
		СтрокаРасписания.НомерДняЦикла = НомерДня;
		СтрокаРасписания.НомерДняПредставление = ПредставленияДняЦикла(НомерДня, СпособЗаполнения);;
		
		Если ЭтоНедельныйГрафик Тогда 
			Для Каждого ИдентификаторВидаВремени Из СоответствиеИдентификаторовВидамВремени Цикл
				ДлительностьРабочейНедели = ДлительностьРабочейНедели + СтрокаРасписания["ЧасовПоВидуВремени" + ИдентификаторВидаВремени.Ключ];
			КонецЦикла;
		КонецЕсли;	
		
	КонецЦикла;		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	СохранитьИЗакрыть();	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Модифицированность = Ложь;
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт 
	Если СпособЗаполнения = ПредопределенноеЗначение("Перечисление.СпособыЗаполненияГрафикаРаботы.ПоЦикламПроизвольнойДлины")
		И Не ЗначениеЗаполнено(ДатаОтсчета) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнена дата отсчета.';uk='Не заповнено дата відліку.'"),
													,
													"ДатаОтсчета");
		Возврат;													
													
	КонецЕсли;	
	
	Если ПроверитьЗаполнение() Тогда
		НастройкиГрафика = ПараметрыЗаполненияГрафика();
		Модифицированность = Ложь;
		Закрыть(НастройкиГрафика);		
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьДоступностьЭлементов(Форма)
	
	Форма.Элементы.ДатаОтсчета.Доступность = Форма.СпособЗаполнения = ПредопределенноеЗначение("Перечисление.СпособыЗаполненияГрафикаРаботы.ПоЦикламПроизвольнойДлины");
	УстановитьДоступностьЭлементовСуммированногоУчета(Форма);
	УстановитьДоступностьЭлементовНеполногоРабочегоВремени(Форма);
	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовНеполногоРабочегоВремени(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"НеполноеРабочееВремяПереключатель",
		"Доступность",
		Форма.НеполноеРабочееВремя);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"СчитатьНормуПоДругомуГрафику",
		"Доступность",
		Форма.НеполноеРабочееВремя);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ГрафикПолногоВремени",
		"Доступность",
		Форма.СчитатьНормуПоДругомуГрафику);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовСуммированногоУчета(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ОпределениеНормыВремениГруппа",
		"Видимость",
		Форма.ИспользоватьОплатуПереработокСуммированногоУчета);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ОпределениеНормыВремениГруппа",
		"Доступность",
		Форма.СуммированныйУчетРабочегоВремени);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"СпособОпределенияНормыСуммированногоУчета",
		"Доступность",
		Форма.СуммированныйУчетРабочегоВремени);
		
	УстановитьДоступностьГрафикаНормыПриСуммированномУчете(Форма);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьГрафикаНормыПриСуммированномУчете(Форма);

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ГрафикНормыПриСуммированномУчете",
		"Доступность",
		Форма.СпособОпределенияНормыСуммированногоУчета = ПредопределенноеЗначение("Перечисление.СпособыОпределенияНормыСуммированногоУчета.ПоДаннымДругогоГрафика"));

КонецПроцедуры

&НаСервере
Процедура ПараметрыВДанныеФормы()
	Параметры.Свойство("ПроизводственныйКалендарь", ПроизводственныйКалендарь);
	Параметры.Свойство("ДлительностьРабочейНедели", ДлительностьРабочейНедели);
	Параметры.Свойство("ГрафикПолногоВремени", ГрафикПолногоВремени);
	Параметры.Свойство("ДатаОтсчета", ДатаОтсчета);
	Параметры.Свойство("НеполноеРабочееВремя", НеполноеРабочееВремя);
	Параметры.Свойство("НеполныйРабочийДень", НеполныйРабочийДень);
	Параметры.Свойство("СокращеннаяРабочаяНеделя", СокращеннаяРабочаяНеделя);
	Параметры.Свойство("СуммированныйУчетРабочегоВремени", СуммированныйУчетРабочегоВремени);
	Параметры.Свойство("СпособОпределенияНормыСуммированногоУчета", СпособОпределенияНормыСуммированногоУчета);
	Параметры.Свойство("ГрафикНормыПриСуммированномУчете", ГрафикНормыПриСуммированномУчете);
	Параметры.Свойство("СчитатьНормуПоДругомуГрафику", СчитатьНормуПоДругомуГрафику);
	Параметры.Свойство("УчитыватьПраздники", УчитыватьПраздники);
	Параметры.Свойство("УчитыватьПредпраздничныеДни", УчитыватьПредпраздничныеДни);
					
	Если Не Параметры.Свойство("СпособЗаполнения", СпособЗаполнения) Тогда 
		СпособЗаполнения = Перечисления.СпособыЗаполненияГрафикаРаботы.ПоНеделям;	
	КонецЕсли;	
	
	Если ПроизводственныйКалендарь.Пустая() Тогда
		УстановитьПроизводственныйКалендарьПоУмолчанию();
	КонецЕсли;	
	
	ИспользуемыеВидыВремени = Неопределено;
	Параметры.Свойство("ИспользуемыеВидыВремени", ИспользуемыеВидыВремени); 
	ЗаполнитьСписокВидовВремени(ИспользуемыеВидыВремени);
	
	Если ДлительностьРабочейНедели = 0 Тогда
		ДлительностьРабочейНедели = 40;
	КонецЕсли;	
	
	УстановитьПереключательНеполногоРабочегоВремени(ЭтаФорма);
	
	ИспользоватьОплатуПереработокСуммированногоУчета = РасчетЗарплатыРасширенный.НастройкиРасчетаЗарплаты().ИспользоватьОплатуПереработокСуммированногоУчета;
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьСписокВидовВремени(ИспользуемыеВидыВремени = Неопределено)
	Если ИспользуемыеВидыВремени = Неопределено Тогда
		ИспользуемыеВидыВремени = Новый Массив;
		Для Каждого СтрокаВидаВремени Из СписокВидовВремени Цикл
			Если СтрокаВидаВремени.Использовать Тогда
		    	ИспользуемыеВидыВремени.Добавить(СтрокаВидаВремени.ВидВремени);
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;	
	
	СписокВидовВремени.Очистить();
	
	Если ИспользуемыеВидыВремени.Количество() = 0 Тогда 
		ИспользуемыеВидыВремени.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.Явка"));
	КонецЕсли;	
	
	НастройкиУчетаВремени = УчетРабочегоВремени.НастройкиУчетаВремени();
		
	Явка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.Явка");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("УчитыватьНочныеЧасы", НастройкиУчетаВремени.УчитыватьНочныеЧасы);
	Запрос.УстановитьПараметр("УчитыватьВечерниеЧасы", НастройкиУчетаВремени.УчитыватьВечерниеЧасы);
	Запрос.УстановитьПараметр("ИспользоватьНесколькоВидовПлановогоВремени", НастройкиУчетаВремени.ИспользоватьНесколькоВидовПлановогоВремени);
	Запрос.УстановитьПараметр("УчитыватьВремяНаКормлениеРебенка", Ложь);
	Запрос.УстановитьПараметр("МассивИспользуемыхВидовВремени", ИспользуемыеВидыВремени);
	Запрос.УстановитьПараметр("Явка", Явка);
	Запрос.УстановитьПараметр("РаботаНочныеЧасы", ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.РаботаНочныеЧасы"));
	Запрос.УстановитьПараметр("РаботаВечерниеЧасы", ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.РаботаВечерниеЧасы"));
    Запрос.УстановитьПараметр("Праздники", ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.Праздники"));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыИспользованияРабочегоВремени.Ссылка КАК ВидВремени,
	|	ВЫБОР
	|		КОГДА ВидыИспользованияРабочегоВремени.Ссылка = &Явка
	|			ТОГДА 1
	|		КОГДА ВидыИспользованияРабочегоВремени.Ссылка = &РаботаНочныеЧасы
	|			ТОГДА 2
	|		КОГДА ВидыИспользованияРабочегоВремени.Ссылка = &РаботаВечерниеЧасы
	|			ТОГДА 3
	|		ИНАЧЕ 5
	|	КОНЕЦ + ВЫБОР
	|		КОГДА ВидыИспользованияРабочегоВремени.Ссылка В (&МассивИспользуемыхВидовВремени)
	|			ТОГДА 0
	|		ИНАЧЕ 6
	|	КОНЕЦ КАК Приоритет,
	|	ВидыИспользованияРабочегоВремени.Наименование,
	|	ВидыИспользованияРабочегоВремени.БуквенныйКод
	|ИЗ
	|	Справочник.ВидыИспользованияРабочегоВремени КАК ВидыИспользованияРабочегоВремени
	|ГДЕ
	|	(&ИспользоватьНесколькоВидовПлановогоВремени
	|				И ВидыИспользованияРабочегоВремени.ОсновноеВремя = &Явка
	|			ИЛИ ВидыИспользованияРабочегоВремени.Ссылка = &Явка
	|			ИЛИ ВидыИспользованияРабочегоВремени.ОсновноеВремя = &РаботаВечерниеЧасы
	|				И &УчитыватьВечерниеЧасы
	|			ИЛИ ВидыИспользованияРабочегоВремени.ОсновноеВремя = &РаботаНочныеЧасы
	|				И &УчитыватьНочныеЧасы
	|			ИЛИ ВидыИспользованияРабочегоВремени.Ссылка В (&МассивИспользуемыхВидовВремени)
	|				И ВидыИспользованияРабочегоВремени.Ссылка <> &Праздники
	|				И (НЕ ВидыИспользованияРабочегоВремени.НеИспользуется
	|					ИЛИ ВидыИспользованияРабочегоВремени.Ссылка В (&МассивИспользуемыхВидовВремени))
	|				И (НЕ ВидыИспользованияРабочегоВремени.ПометкаУдаления
	|					ИЛИ ВидыИспользованияРабочегоВремени.Ссылка В (&МассивИспользуемыхВидовВремени)))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаВидаВремени = СписокВидовВремени.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаВидаВремени, Выборка);
		
		СтрокаВидаВремени.Использовать = ИспользуемыеВидыВремени.Найти(Выборка.ВидВремени) <> Неопределено;
	КонецЦикла;	
	
	Если НеполноеРабочееВремя Тогда
		ВидыСокращенногоВремени = Новый Массив;
		ВидыСокращенногоВремени.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.СокращенноеРабочееВремя"));
		ВидыСокращенногоВремени.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.РаботаВРежимеНеполногоВремени"));
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ВидыСокращенногоВремени", ВидыСокращенногоВремени);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыИспользованияРабочегоВремени.Ссылка КАК ВидВремени,
		|	ВидыИспользованияРабочегоВремени.БуквенныйКод,
		|	ВидыИспользованияРабочегоВремени.Наименование
		|ИЗ
		|	Справочник.ВидыИспользованияРабочегоВремени КАК ВидыИспользованияРабочегоВремени
		|ГДЕ
		|	ВидыИспользованияРабочегоВремени.ОсновноеВремя В(&ВидыСокращенногоВремени)";
		
		Выборка = Запрос.Выполнить().Выбрать();
	
		Пока Выборка.Следующий() Цикл
			Если ИспользуемыеВидыВремени.Найти(Выборка.ВидВремени) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаВидаВремени = СписокВидовВремени.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаВидаВремени, Выборка);
			
		КонецЦикла;	

	КонецЕсли;	
		
КонецПроцедуры	

&НаСервере
Процедура УстановитьПроизводственныйКалендарьПоУмолчанию()
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПроизводственныеКалендари.Ссылка КАК ПроизводственныйКалендарь
	|ИЗ
	|	Справочник.ПроизводственныеКалендари КАК ПроизводственныеКалендари
	|ГДЕ
	|	НЕ ПроизводственныеКалендари.ПометкаУдаления");
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ПроизводственныйКалендарь = Выборка.ПроизводственныйКалендарь;
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура ДобавитьКолонкиВидовВремени(ОписаниеВидовВремени)	
	Если СоответствиеИдентификаторовВидамВремени = Неопределено Тогда
		ИдентификаторыВидовВремени = Новый Соответствие;
	Иначе	
		ИдентификаторыВидовВремени = ОбщегоНазначенияКлиентСервер.СкопироватьСоответствие(СоответствиеИдентификаторовВидамВремени);
	КонецЕсли;	
	
	ДобавляемыеРеквизиты = Новый Массив;
	
	Для Каждого ОписаниеВидаВремени Из ОписаниеВидовВремени Цикл
		
		Идентификатор = ИдентификаторВидаВремени(ОписаниеВидаВремени.ВидВремени);
		
		РеквизитЧасовПоВидуВремени = Новый РеквизитФормы("ЧасовПоВидуВремени" + Идентификатор, 
													Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(4, 2, ДопустимыйЗнак.Неотрицательный)),    
													"РасписаниеРаботы");
											
		ДобавляемыеРеквизиты.Добавить(РеквизитЧасовПоВидуВремени);
		
		ИдентификаторыВидовВремени.Вставить(Идентификатор, ОписаниеВидаВремени.ВидВремени); 
		
	КонецЦикла;	
	
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	Для Каждого ОписаниеВидаВремени Из ОписаниеВидовВремени Цикл
		Идентификатор = ИдентификаторВидаВремени(ОписаниеВидаВремени.ВидВремени);
		
		ЧасовПоВидуВремениЭлемент = Элементы.Вставить("ЧасовПоВидуВремени" + Идентификатор, Тип("ПолеФормы"), Элементы.РасписаниеРаботы);
		ЧасовПоВидуВремениЭлемент.ПутьКДанным = "РасписаниеРаботы.ЧасовПоВидуВремени" + Идентификатор;
		ЧасовПоВидуВремениЭлемент.Вид = ВидПоляФормы.ПолеВвода;
		ЧасовПоВидуВремениЭлемент.ТолькоПросмотр = Ложь;
		ЧасовПоВидуВремениЭлемент.ОтображатьВШапке = Истина;
		ЧасовПоВидуВремениЭлемент.Заголовок = ОписаниеВидаВремени.Наименование;
		ЧасовПоВидуВремениЭлемент.Ширина = 4;
		ЧасовПоВидуВремениЭлемент.ВысотаЗаголовка = 2;
		ЧасовПоВидуВремениЭлемент.РастягиватьПоГоризонтали = Ложь;
	КонецЦикла;		
	
	СоответствиеИдентификаторовВидамВремени = Новый ФиксированноеСоответствие(ИдентификаторыВидовВремени);
КонецПроцедуры	

&НаСервере
Процедура УдалитьКолонкиВидовВремени(ВидыВремени)
	ИдентификаторыВидовВремени = ОбщегоНазначенияКлиентСервер.СкопироватьСоответствие(СоответствиеИдентификаторовВидамВремени);
	
	УдаляемыеРеквизиты = Новый Массив;
	
	Для Каждого УдаляемыйВидВремени Из ВидыВремени Цикл
		
		Идентификатор = ИдентификаторВидаВремени(УдаляемыйВидВремени);
		
		УдаляемыеРеквизиты.Добавить("РасписаниеРаботы.ЧасовПоВидуВремени" + Идентификатор);										
		
		ИдентификаторыВидовВремени.Удалить(Идентификатор);
	КонецЦикла;	
	
	ИзменитьРеквизиты(, УдаляемыеРеквизиты);
	
	Для Каждого ИмяУдаляемогоРеквизита Из УдаляемыеРеквизиты Цикл
		УдаляемыйЭлемент = Элементы.Найти(ИмяУдаляемогоРеквизита);
		
		Если УдаляемыйЭлемент <> Неопределено Тогда
			Элементы.Удалить(УдаляемыйЭлемент);			
		КонецЕсли;	
	КонецЦикла;		
	
	СоответствиеИдентификаторовВидамВремени = Новый ФиксированноеСоответствие(ИдентификаторыВидовВремени);
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьСтрокиРасписанияКалендаряПоУмолчанию()
	РасписаниеРаботы.Очистить();
	Если СпособЗаполнения = Перечисления.СпособыЗаполненияГрафикаРаботы.ПоНеделям Тогда
		Идентификатор = ИдентификаторВидаВремени(СписокВидовВремени[0].ВидВремени);
		Для НомерДня = 1 По 7 Цикл                                    
			СтрокаРасписания = РасписаниеРаботы.Добавить();
			СтрокаРасписания.НомерДняЦикла = НомерДня;	
			СтрокаРасписания.НомерДняПредставление = ПредставленияДняЦикла(НомерДня, СпособЗаполнения);
			
			Если НомерДня <= 5 Тогда
				СтрокаРасписания["ЧасовПоВидуВремени" + Идентификатор] = 8;
			КонецЕсли;	
		КонецЦикла;	
		ДлительностьРабочейНедели = 40;
	КонецЕсли;		
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьРасписаниеРаботыИзНастроек(ЧасыПоДнямЦикла)
	Если ЧасыПоДнямЦикла.Количество() > 0 Тогда
		Для Каждого ВремяЗаДень Из ЧасыПоДнямЦикла Цикл
			СтрокаРасписания = РасписаниеРаботы.Добавить();
			СтрокаРасписания.НомерДняЦикла = ВремяЗаДень.Ключ;
			СтрокаРасписания.НомерДняПредставление = ПредставленияДняЦикла(ВремяЗаДень.Ключ, СпособЗаполнения);
			
			ЧасыПоВидамВремени = ВремяЗаДень.Значение;
			
			Если ЧасыПоВидамВремени <> Неопределено И ЧасыПоВидамВремени.Количество() > 0 Тогда
				СтрокаРасписания.ДеньВключенВГрафик = Истина;
				
				Для Каждого ЧасовПоВидуВремени Из ЧасыПоВидамВремени Цикл
					Идентификатор = ИдентификаторВидаВремени(ЧасовПоВидуВремени.Ключ);
			
					СтрокаРасписания["ЧасовПоВидуВремени" + Идентификатор] = ЧасовПоВидуВремени.Значение;
						
				КонецЦикла;	
			КонецЕсли;	
		КонецЦикла;	
		
		РасписаниеРаботы.Сортировать("НомерДняЦикла");
	Иначе
		ЗаполнитьСтрокиРасписанияКалендаряПоУмолчанию();
	КонецЕсли;	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Функция ПредставленияДняЦикла(НомерДня, СпособЗаполнения)
	Если СпособЗаполнения = ПредопределенноеЗначение("Перечисление.СпособыЗаполненияГрафикаРаботы.ПоНеделям") Тогда
		Возврат Формат(НачалоНедели('20100101') + (НомерДня - 1) * 86400, "ДФ=ддд");
	Иначе
		Возврат Формат(НомерДня, "ЧГ=");
	КонецЕсли;	
КонецФункции	

&НаСервере
Процедура ИспользованиеВидаВремениПриИзмененииНаСервере(ИдентификаторТекущейСтроки)
	ОписаниеВидаВремени = СписокВидовВремени.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	
	Если ОписаниеВидаВремени.Использовать Тогда
		ОписаниеДобавляемыхВидовВремени = Новый Массив;
		ОписаниеДобавляемыхВидовВремени.Добавить(ОписаниеВидаВремени);
		
		ДобавитьКолонкиВидовВремени(ОписаниеДобавляемыхВидовВремени);
	Иначе
		УдаляемыеВидыВремени = Новый Массив;
		УдаляемыеВидыВремени.Добавить(ОписаниеВидаВремени.ВидВремени);
		
		УдалитьКолонкиВидовВремени(УдаляемыеВидыВремени);
	КонецЕсли;		
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Функция ИдентификаторВидаВремени(ВидВремени)
	Возврат СтрЗаменить(Строка(ВидВремени.УникальныйИдентификатор()), "-", "");	
КонецФункции	

&НаСервере
Функция ЧасыПоДнямЦикла()
	ЧасыПоДнямЦикла = Новый Соответствие;
	
	Для Каждого ДеньЦикла Из РасписаниеРаботы Цикл
		ЧасыЗаДень = Новый Соответствие;
		
		Для Каждого ИдентификаторВидаВремени Из СоответствиеИдентификаторовВидамВремени Цикл
			ЧасовПоВидуВремени = ДеньЦикла["ЧасовПоВидуВремени" + ИдентификаторВидаВремени.Ключ];
			
			ЧасыЗаДень.Вставить(ИдентификаторВидаВремени.Значение, ЧасовПоВидуВремени);				
		
		КонецЦикла;	
		
		ЧасыПоДнямЦикла.Вставить(ДеньЦикла.НомерДняЦикла, ЧасыЗаДень);
	КонецЦикла;		
	
	Возврат ЧасыПоДнямЦикла;
КонецФункции	

&НаКлиенте
Функция ПараметрыЗаполненияГрафика()
	ИспользуемыеВидыВремени = Новый Массив;
	
	СтрокиВидовВремени = СписокВидовВремени.НайтиСтроки(Новый Структура("Использовать", Истина));
	
	Для Каждого ОписаниеВидаВремени Из СтрокиВидовВремени Цикл
		ИспользуемыеВидыВремени.Добавить(ОписаниеВидаВремени.ВидВремени);		
	КонецЦикла;	
	
	Если ИспользуемыеВидыВремени.Количество() = 0 Тогда
		ИспользуемыеВидыВремени.Добавить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.Явка"));
	КонецЕсли;	
	
	ПараметрыЗаполненияГрафика = Новый Структура;
	ПараметрыЗаполненияГрафика.Вставить("СпособЗаполнения", СпособЗаполнения);
	ПараметрыЗаполненияГрафика.Вставить("ДлительностьРабочейНедели", ДлительностьРабочейНедели);
    ПараметрыЗаполненияГрафика.Вставить("ИспользуемыеВидыВремени", ИспользуемыеВидыВремени);
	ПараметрыЗаполненияГрафика.Вставить("ПроизводственныйКалендарь", ПроизводственныйКалендарь);
	ПараметрыЗаполненияГрафика.Вставить("ЧасыПоДнямЦикла", ЧасыПоДнямЦикла());
	ПараметрыЗаполненияГрафика.Вставить("ДатаОтсчета", ДатаОтсчета);
	ПараметрыЗаполненияГрафика.Вставить("НеполноеРабочееВремя", НеполноеРабочееВремя);
	ПараметрыЗаполненияГрафика.Вставить("НеполныйРабочийДень", НеполныйРабочийДень);
	ПараметрыЗаполненияГрафика.Вставить("СокращеннаяРабочаяНеделя", СокращеннаяРабочаяНеделя);
	ПараметрыЗаполненияГрафика.Вставить("ГрафикПолногоВремени", ГрафикПолногоВремени);
	ПараметрыЗаполненияГрафика.Вставить("СуммированныйУчетРабочегоВремени", СуммированныйУчетРабочегоВремени);
	ПараметрыЗаполненияГрафика.Вставить("СпособОпределенияНормыСуммированногоУчета", СпособОпределенияНормыСуммированногоУчета);
	ПараметрыЗаполненияГрафика.Вставить("ГрафикНормыПриСуммированномУчете", ГрафикНормыПриСуммированномУчете);
	ПараметрыЗаполненияГрафика.Вставить("СчитатьНормуПоДругомуГрафику", СчитатьНормуПоДругомуГрафику);
	ПараметрыЗаполненияГрафика.Вставить("УчитыватьПраздники", УчитыватьПраздники);
	ПараметрыЗаполненияГрафика.Вставить("УчитыватьПредпраздничныеДни", УчитыватьПредпраздничныеДни);
	ПараметрыЗаполненияГрафика.Вставить("Ссылка", Параметры.Ссылка);

	Возврат ПараметрыЗаполненияГрафика;
	
КонецФункции	

&НаСервере
Процедура ВидГрафикаПриИзмененииНаСервере()
	ДлительностьРабочейНедели = 40;
	
	УстановитьНастройкиТаблицыРасписаниеРаботы(); 	
	
	ЗаполнитьСтрокиРасписанияКалендаряПоУмолчанию();
	
	НастроитьДоступностьЭлементов(ЭтаФорма);
	
	Если СпособЗаполнения = Перечисления.СпособыЗаполненияГрафикаРаботы.ПоЦикламПроизвольнойДлины 
		И ДатаОтсчета = '00010101' Тогда
		
		ДатаОтсчета = НачалоГода(ТекущаяДатаСеанса());
	КонецЕсли;	
		
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиТаблицыРасписаниеРаботы()
	Если СпособЗаполнения = Перечисления.СпособыЗаполненияГрафикаРаботы.ПоНеделям Тогда
		Элементы.РасписаниеРаботыДень.Заголовок = НСтр("ru='День недели';uk='День тижня'");
		Элементы.РасписаниеРаботы.ИзменятьПорядокСтрок = Ложь;
		Элементы.РасписаниеРаботы.ИзменятьСоставСтрок = Ложь;
		Элементы.РасписаниеРаботыДобавить.Видимость = Ложь;
		Элементы.РасписаниеРаботыУдалить.Видимость = Ложь;
		Элементы.РасписаниеРаботыПереместитьВверх.Видимость = Ложь;
		Элементы.РасписаниеРаботыПереместитьВниз.Видимость = Ложь;
		Элементы.ДлительностьРабочейНедели.ТолькоПросмотр = Истина;
	Иначе
		Элементы.РасписаниеРаботыДень.Заголовок = НСтр("ru='Номер дня';uk='Номер дня'");
		Элементы.РасписаниеРаботы.ИзменятьПорядокСтрок = Истина;
		Элементы.РасписаниеРаботы.ИзменятьСоставСтрок = Истина;
		Элементы.РасписаниеРаботыДобавить.Видимость = Истина;
		Элементы.РасписаниеРаботыУдалить.Видимость = Истина;
		Элементы.РасписаниеРаботыПереместитьВверх.Видимость = Истина;
		Элементы.РасписаниеРаботыПереместитьВниз.Видимость = Истина;
		Элементы.ДлительностьРабочейНедели.ТолькоПросмотр = Ложь;
	КонецЕсли;		
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПереключательНеполногоРабочегоВремени(Форма)
	Если Форма.НеполноеРабочееВремя Тогда
		Если Форма.НеполныйРабочийДень Тогда
			Форма.НеполноеРабочееВремяПереключатель = 1;
		ИначеЕсли Форма.СокращеннаяРабочаяНеделя Тогда  
			Форма.НеполноеРабочееВремяПереключатель = 2;
		КонецЕсли;	
		Если Форма.НеполноеРабочееВремяПереключатель = 0 Тогда
			Форма.НеполноеРабочееВремяПереключатель = 1;
		КонецЕсли;	
		Если Форма.НеполноеРабочееВремяПереключатель = 1 Тогда
			Форма.НеполныйРабочийДень = Истина;
		Иначе
			Форма.СокращеннаяРабочаяНеделя = Истина;
		КонецЕсли;
	Иначе
		Форма.НеполноеРабочееВремяПереключатель = 0;
		Форма.СокращеннаяРабочаяНеделя = Ложь;
		Форма.НеполныйРабочийДень = Ложь;
	КонецЕсли;		
КонецПроцедуры	

#КонецОбласти
