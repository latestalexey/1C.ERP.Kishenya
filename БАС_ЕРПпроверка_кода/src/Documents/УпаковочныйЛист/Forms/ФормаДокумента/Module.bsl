&НаКлиенте
Перем КэшированныеЗначения;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	УстановитьУсловноеОформление();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий);
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	МодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	ЗаполнитьСлужебныеРеквизитыТЧТовары();
	УпаковочныеЛистыСервер.ПеренумероватьСтроки(ЭтаФорма, Объект.Товары);
	УпаковочныеЛистыСервер.СформироватьНавигационнуюНадпись(ЭтаФорма,
		ЗаголовокНачальногоУровня(Объект.Ссылка, Объект.Код));
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ИсточникВыбора.ИмяФормы = "Обработка.ЗагрузкаДанныхИзВнешнихФайлов.Форма.Форма" Тогда
		
		ПолучитьЗагруженныеТоварыИзХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаВыбора" Тогда
		
		ТекущиеДанные.Номенклатура = ВыбранноеЗначение;
		НоменклатураУпаковочныйЛистПриИзменении("ТоварыНоменклатура", КэшированныеЗначения);
		Элементы.Товары.ТекущийЭлемент = Элементы.ТоварыКоличествоУпаковок;
		Элементы.Товары.ТекущийЭлемент = Элементы.ТоварыНоменклатура;
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Документ.УпаковочныйЛист.Форма.ФормаВыбора" Тогда
		
		ТекущиеДанные.УпаковочныйЛист = ВыбранноеЗначение;
		НоменклатураУпаковочныйЛистПриИзменении("ТоварыУпаковочныйЛист", КэшированныеЗначения);
		Элементы.Товары.ЗакончитьРедактированиеСтроки(Ложь);
		
	ИначеЕсли НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если Не Объект.РежимПросмотраПоТоварам Тогда
		
		ДокументОбъект = РеквизитФормыВЗначение("Объект");
		
		Если Не ДокументОбъект.ПроверитьЗаполнение() Тогда
			Объект.РежимПросмотраПоТоварам = Истина;
			РежимПросмотраПриИзмененииСервер();
			Отказ = Истина;
		КонецЕсли;
		
		ПроверяемыеРеквизиты.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидПриИзменении(Элемент)
	
	ВидПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьНавигацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПриПереходеНаДругойУровеньСервер(НавигационнаяСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПросмотраПриИзменении(Элемент)
	РежимПросмотраПриИзмененииСервер();
	УпаковочныеЛистыКлиент.ОбновитьКешированныеЗначенияДляТЧСУпаковочнымиЛистами(Элементы.Товары, КэшированныеЗначения);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если УпаковочныеЛистыКлиент.ПроверитьПодготовитьПереходВУпаковочныйЛистПриВыборе(Элементы.Товары, Поле.Имя) Тогда
		ПриПереходеНаДругойУровеньСервер(Элементы.Товары.ТекущиеДанные.УпаковочныйЛист);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	УпаковочныеЛистыКлиент.ПриНачалеРедактированияТЧСУпаковочнымиЛистами(ЭтаФорма, КэшированныеЗначения, НоваяСтрока)
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УпаковочныеЛистыКлиент.ПриОкончанииРедактированияТЧСУпаковочнымиЛистами(ЭтаФорма, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	УпаковочныеЛистыКлиент.ПередНачаломДобавленияВТЧСУпаковочнымиЛистами(Элементы.Товары, Отказ, Копирование, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	УпаковочныеЛистыКлиент.ПередУдалениемСтрокТЧСУпаковочнымиЛистами(Элементы.Товары, КэшированныеЗначения, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	ТоварыПослеУдаленияСервер(КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПоставщикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьНоменклатуруПоНоменклатуреПоставщика");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус",
		Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерий, Неопределено));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураУпаковочныйЛистПриИзменении(Элемент)
	
	НоменклатураУпаковочныйЛистПриИзменении(Элемент.Имя, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.УпаковочныйЛистРодитель) Тогда
		ПересчитатьКоличествоМест();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УпаковочныеЛистыКлиент.НачалоВыбораТоварногоМеста(ЭтаФорма, Элемент, СтандартнаяОбработка, Объект.РежимПросмотраПоТоварам);
	
КонецПроцедуры

&НаСервере
Процедура ТоварыПослеУдаленияСервер(КэшированныеЗначения)
	
	УпаковочныеЛистыСервер.ПослеУдаленияВТЧСУпаковочнымиЛистами(ЭтаФорма, Объект.Товары, Объект.РежимПросмотраПоТоварам);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковочныйЛистРодительОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(Неопределено, Элементы.Товары.ТекущиеДанные.УпаковочныйЛистРодитель);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковочныйЛистРодительОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	
	ВыбранноеЗначение.Значение            		 = Элементы.Товары.ТекущиеДанные.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий(Элемент.ТекстРедактирования);
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
Процедура ЗагрузитьИзВнешнегоФайла(Команда)
	
	ПараметрыФормы = Новый Структура();
	
	ПараметрыФормы.Вставить("ОтборПоТипуНоменклатуры", Новый ФиксированныйМассив(НоменклатураКлиентСервер.ОтборПоТоваруМногооборотнойТаре(Ложь)));
	ПараметрыФормы.Вставить("ЗагружатьУпаковочныеЛисты", Истина);
	
	ОткрытьФорму("Обработка.ЗагрузкаДанныхИзВнешнихФайлов.Форма.Форма",
		ПараметрыФормы,
		ЭтаФорма,
		УникальныйИдентификатор);
		
КонецПроцедуры

&НаКлиенте
Процедура НаУровеньВверх(Команда)
	
	НаУровеньВверхСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура Распаковать(Команда)
	
	УпаковочныеЛистыКлиент.РаспаковатьУпаковочныйЛист(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Упаковать(Команда)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru='Выберите строки для объединения.';uk='Виберіть рядки для об''єднання.'");
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	НовыйУпаковочныйЛист = УпаковатьСервер();
	
	Если ЗначениеЗаполнено(НовыйУпаковочныйЛист) Тогда
		ТекстОповещения = НСтр("ru='Создание:';uk='Створення:'");
		ПоказатьОповещениеПользователя(ТекстОповещения,
			ПолучитьНавигационнуюСсылку(НовыйУпаковочныйЛист),
			НовыйУпаковочныйЛист,
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтроку(Команда)
	
	ТаблицаФормы  = Элементы.Товары;
	ДанныеТаблицы = Объект.Товары;
	
	Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуЗавершение", ЭтотОбъект);
	УпаковочныеЛистыКлиент.РазбитьСтрокуТЧСУпаковочнымиЛистами(ДанныеТаблицы, ТаблицаФормы, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтрокуЗавершение(НоваяСтрока, ДополнительныеПараметры) Экспорт 
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Если НоваяСтрока <> Неопределено Тогда
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
		
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(НоваяСтрока, СтруктураДействий, КэшированныеЗначения);
		
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств(Команда)
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтотОбъект, Объект.Ссылка);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СтандартныеПодсистемы_Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.УпаковочныйЛист);
	
	УпаковочныеЛистыСервер.ПриЧтенииСозданииФормыСУпаковочнымиЛистами(ЭтаФорма, Объект.Товары,
		ЗаголовокНачальногоУровня(Объект.Ссылка, Объект.Код));
	ЗаполнитьСлужебныеРеквизитыТЧТовары();
	
	ВидПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьЗагруженныеТоварыИзХранилища(АдресТоваровВХранилище)
	
	ТоварыИзХранилища = ПолучитьИзВременногоХранилища(АдресТоваровВХранилище);
	
	СтрокиДляДополнения = Новый Массив;
	Для Каждого СтрокаТоваров Из ТоварыИзХранилища Цикл
		Если ЗначениеЗаполнено(СтрокаТоваров.УпаковочныйЛист)
			И СтрокаТоваров.УпаковочныйЛист = Объект.Ссылка Тогда
			ТекстСообщения = НСтр("ru='Нельзя включить %УпаковочныйЛист в состав самого себя.';uk='Не можна включити %УпаковочныйЛист до складу самого себе.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%УпаковочныйЛист", СтрокаТоваров.УпаковочныйЛист);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаТоваров.УпаковочныйЛист)
			И УпаковочныеЛисты.НайтиСтроки(Новый Структура("УпаковочныйЛист",СтрокаТоваров.УпаковочныйЛист)).Количество() > 0 Тогда
			ТекстСообщения = НСтр("ru='%УпаковочныйЛист уже был добавлен в табличную часть.';uk='%УпаковочныйЛист вже був доданий в табличну частину.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%УпаковочныйЛист", СтрокаТоваров.УпаковочныйЛист);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
		КонецЕсли;
		СтрокаТЧТовары = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧТовары, СтрокаТоваров);
		Если ЗначениеЗаполнено(СтрокаТоваров.УпаковочныйЛист) Тогда
			СтрокиДляДополнения.Добавить(СтрокаТЧТовары);
			СтрокаТЧТовары.ЭтоУпаковочныйЛист = Истина;
			СтрокаТЧТовары.Количество = 1;
			СтрокаТЧТовары.КоличествоУпаковок = 1;
		КонецЕсли;
	КонецЦикла;
	
	УпаковочныеЛистыСервер.ДополнитьСтрокамиПоУпаковочнымЛистам(ЭтаФорма, Объект.Товары, СтрокиДляДополнения);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	УпаковочныеЛистыСервер.ЗаполнитьСлужебныеРеквизиты(ЭтаФорма, Объект.Товары, СтруктураДействий);
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий);
	
	// Загрузка идет в верхний уровень, нужно перейти
	Если Не Объект.РежимПросмотраПоТоварам Тогда
		УпаковочныеЛистыСервер.ПриПереходеНаДругойУровень(ЭтаФорма,
			Объект.Товары, "0", ЗаголовокНачальногоУровня(Объект.Ссылка,Объект.Код));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);
	
	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыНоменклатураПоставщика.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.ЭтоУпаковочныйЛист");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<номенклатура поставщика не используется>';uk='<номенклатура постачальника не використовується>'"));
	
	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтаФорма, "СерииВсегдаВТЧТовары");
	
	//
	
	УпаковочныеЛистыСервер.УстановитьУсловноеОформлениеСУчетомУпаковочныхЛистов(ЭтаФорма);
	
КонецПроцедуры

// Обработчик, вызываемый после закрытия вопроса пользователю о распаковке
//
&НаКлиенте
Процедура ПослеЗакрытияВопросаОРаспаковке(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		РаспаковатьСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НоменклатураУпаковочныйЛистПриИзменении(ИмяПоля, КэшированныеЗначения)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	
	Если ЗначениеЗаполнено(Объект.Ссылка)
		И ТекущаяСтрока.УпаковочныйЛист = Объект.Ссылка Тогда
		
		ТекстОшибки = НСтр("ru='Нельзя включить %УпаковочныйЛист% в состав самого себя.';uk='Не можна включити %УпаковочныйЛист% до складу самого себе.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%УпаковочныйЛист%", ТекущаяСтрока.УпаковочныйЛист);
		Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Товары", ТекущаяСтрока.НомерСтроки, "УпаковочныйЛист");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,Поле);
		ТекущаяСтрока.УпаковочныйЛист = КэшированныеЗначения.УпаковочныйЛист;
		
	КонецЕсли;
	
	СтруктураДействийСТекущейСтрокой = Новый Структура;
	СтруктураДействийСТекущейСтрокой.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействийСТекущейСтрокой.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействийСТекущейСтрокой.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействийСТекущейСтрокой.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	СтруктураДействийСТекущейСтрокой.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействийСТекущейСтрокой.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "Товары"));
	СтруктураДействийСТекущейСтрокой.Вставить("ПроверитьСериюРассчитатьСтатус",
		Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерий, Неопределено));
	
	Если ИмяПоля = "ТоварыУпаковочныйЛист" Тогда
		СтруктураДействийСДобавляемымиСтроками = Новый Структура;
		СтруктураДействийСДобавляемымиСтроками.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
		СтруктураДействийСДобавляемымиСтроками.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
		СтруктураДействийСДобавляемымиСтроками.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
		Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	Иначе
		СтруктураДействийСДобавляемымиСтроками = Неопределено;
	КонецЕсли;
	
	УпаковочныеЛистыСервер.НоменклатураУпаковочныйЛистПриИзменении(ЭтаФорма, Объект.Товары,
		ИмяПоля, КэшированныеЗначения, СтруктураДействийСТекущейСтрокой, СтруктураДействийСДобавляемымиСтроками);
	
КонецПроцедуры

&НаСервере
Процедура РежимПросмотраПриИзмененииСервер()
	
	УпаковочныеЛистыСервер.РежимПросмотраПриИзменении(ЭтаФорма, Объект.Товары, ЗаголовокНачальногоУровня(Объект.Ссылка, Объект.Код));
	
КонецПроцедуры

&НаСервере
Процедура ПриПереходеНаДругойУровеньСервер(НавигационнаяСсылка)
	
	УпаковочныеЛистыСервер.ПриПереходеНаДругойУровень(ЭтаФорма,
		Объект.Товары, НавигационнаяСсылка, ЗаголовокНачальногоУровня(Объект.Ссылка,Объект.Код));
	
КонецПроцедуры

&НаСервере
Функция УпаковатьСервер()
	
	Возврат УпаковочныеЛистыСервер.УпаковатьСервер(ЭтаФорма);
	
КонецФункции

&НаСервере
Процедура РаспаковатьСервер()
	
	УпаковочныеЛистыСервер.РаспаковатьУпаковочныйЛист(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыТЧТовары()
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	УпаковочныеЛистыСервер.ЗаполнитьСлужебныеРеквизиты(ЭтаФорма, Объект.Товары, СтруктураДействий);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗаголовокНачальногоУровня(Ссылка, Код)
	
	ПредставлениеОбъекта = Ссылка.Метаданные().ПредставлениеОбъекта;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		Возврат ПредставлениеОбъекта + " " + Код;
	Иначе
		Возврат ПредставлениеОбъекта + " " + НСтр("ru='(создание)';uk='(створення)'");
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура НаУровеньВверхСервер()
	
	НайденныеСтроки = УпаковочныеЛисты.НайтиСтроки(Новый Структура("УпаковочныйЛист",УпаковочныйЛистРодитель));
	ПриПереходеНаДругойУровеньСервер(НайденныеСтроки[0].УпаковочныйЛистРодитель);
	
КонецПроцедуры

&НаСервере
Процедура ВидПриИзмененииСервер()
	
	Если Объект.Вид = Перечисления.ВидыУпаковочныхЛистов.Входящий Тогда
		Элементы.Код.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
		Элементы.Код.АвтоОтметкаНезаполненного = Истина;
	Иначе
		Элементы.Код.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
		Элементы.Код.АвтоОтметкаНезаполненного = Ложь;
		Элементы.Код.ОтметкаНезаполненного = Ложь;
	КонецЕсли;
	Элементы.ГруппаПодвал.Видимость = (Объект.Вид = Перечисления.ВидыУпаковочныхЛистов.Исходящий);
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьКоличествоМест()
	
	УпаковочныеЛистыСервер.ПересчитатьКоличествоМест(ЭтаФорма, Объект.Товары)
	
КонецПроцедуры

#Область Серии

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "", ТекущиеДанные = Неопределено)
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			ТекстСообщения = НСтр("ru='Выберите строку товаров, для которой необходимо указать серии.';uk='Виберіть рядок товарів, для якого необхідно зазначити серії.'");
			ПоказатьПредупреждение(Неопределено, ТекстСообщения);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	ТекущиеДанныеИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
	ПараметрыФормыУказанияСерий = ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор);
	
	ЗначениеВозврата = Неопределено;

	
	ОткрытьФорму(ПараметрыФормыУказанияСерий.ИмяФормы,ПараметрыФормыУказанияСерий,ЭтаФорма,,,, Новый ОписаниеОповещения("ОткрытьПодборСерийЗавершение", ЭтотОбъект, Новый Структура("ПараметрыФормыУказанияСерий", ПараметрыФормыУказанияСерий)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерийЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ПараметрыФормыУказанияСерий = ДополнительныеПараметры.ПараметрыФормыУказанияСерий;
    
    
    ЗначениеВозврата = Результат;
    
    Если ЗначениеВозврата <> Неопределено Тогда
        ОбработатьУказаниеСерийНаСервере(ПараметрыФормыУказанияСерий, КэшированныеЗначения);
    КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор)
	
	Возврат НоменклатураСервер.ПараметрыФормыУказанияСерий(Объект, ПараметрыУказанияСерий, ТекущиеДанныеИдентификатор, ЭтаФорма);
	
КонецФункции

&НаСервере
Процедура ОбработатьУказаниеСерийНаСервере(ПараметрыФормыУказанияСерий, КэшированныеЗначения) Экспорт
	
	НоменклатураСервер.ОбработатьУказаниеСерий(Объект,ПараметрыУказанияСерий,ПараметрыФормыУказанияСерий,,КэшированныеЗначения);
	ЗаполнитьСлужебныеРеквизитыТЧТовары();
	
КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.Свойства 

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);

КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
