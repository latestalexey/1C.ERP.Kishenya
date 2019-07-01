
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, Новый Структура("ПрочиеРасходы"), МассивНепроверяемыхРеквизитов, Отказ);
	
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, Новый Структура("ПрочиеДоходы"), МассивНепроверяемыхРеквизитов, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ИнициализироватьДокумент(ДанныеЗаполнения);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихАктивовПассивов") Тогда
		
		Для Каждого ТекСтрока Из ПрочиеРасходы Цикл
			Если НЕ ЗначениеЗаполнено(ТекСтрока.СтатьяАктивовПассивов) Тогда
				ТекСтрока.СтатьяАктивовПассивов = ПланыВидовХарактеристик.СтатьиАктивовПассивов.ПрочиеПассивы;
			КонецЕсли;
		КонецЦикла;
		Для Каждого ТекСтрока Из ПрочиеДоходы Цикл
			Если НЕ ЗначениеЗаполнено(ТекСтрока.СтатьяАктивовПассивов) Тогда
				ТекСтрока.СтатьяАктивовПассивов = ПланыВидовХарактеристик.СтатьиАктивовПассивов.ПрочиеАктивы;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочиеДоходы
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СторнированиеПрочихДоходов Тогда
		ПрочиеРасходы.Очистить();
	Иначе
		ПрочиеДоходы.Очистить();
	КонецЕсли;
	
	Для Каждого Строка ИЗ ПрочиеРасходы Цикл
		Если НЕ ЗначениеЗаполнено(Строка.ДатаОтражения) Тогда
			Строка.ДатаОтражения = Дата;
		КонецЕсли;
	КонецЦикла;
	Для Каждого Строка ИЗ ПрочиеДоходы Цикл
		Если НЕ ЗначениеЗаполнено(Строка.ДатаОтражения) Тогда
			Строка.ДатаОтражения = Дата;
		КонецЕсли;
	КонецЦикла;
	
	//++ НЕ УТ
	ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ПрочиеРасходы);
	ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ПрочиеДоходы);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		УстановитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете();
	КонецЕсли;
	//-- НЕ УТ
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ПрочиеДоходыРасходы.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения
	ДоходыИРасходыСервер.ОтразитьПрочиеДоходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПартииПрочихРасходов(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДоходыРасходыПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	//++ НЕ УТ
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТ
	
	СформироватьСписокРегистровДляКонтроля();
	
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();

	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Валюта = Константы.ВалютаУправленческогоУчета.Получить();
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение
	 И ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СторнированиеПрочихРасходов Тогда
		Массив.Добавить(Движения.ПрочиеРасходы);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

//++ НЕ УТ

Процедура УстановитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете()
	
	Если НЕ Проведен Тогда
		Возврат;
	КонецЕсли;
	
	НепроверяемыеРеквизиты = Новый Структура;
	НепроверяемыеРеквизиты.Вставить("Комментарий");
	
	НепроверяемыеТабличныеЧасти = Новый Структура;
	НепроверяемыеТабличныеЧасти.Вставить("ДополнительныеРеквизиты");
	
	ИзмененияДокумента = ОбщегоНазначенияУТ.ИзмененияДокумента(ЭтотОбъект, НепроверяемыеРеквизиты, НепроверяемыеТабличныеЧасти);
	
	Если ИзмененияДокумента.Свойство("Реквизиты") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ИзмененияДокумента.Свойство("ТабличныеЧасти") Тогда
		РеглУчетПроведениеСервер.НеРегистрироватьКОтражениюВРеглУчете(ДополнительныеСвойства);
		Возврат;
	КонецЕсли; 
	
	ТабличныеЧастиДоходовРасходов = Новый Структура;
	ТабличныеЧастиДоходовРасходов.Вставить("ПрочиеДоходы");
	ТабличныеЧастиДоходовРасходов.Вставить("ПрочиеРасходы");
	
	Для каждого ТабличнаяЧасть Из ИзмененияДокумента.ТабличныеЧасти Цикл
		Если НЕ ТабличныеЧастиДоходовРасходов.Свойство(ТабличнаяЧасть.Ключ) Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТабличнаяЧасть Из ИзмененияДокумента.ТабличныеЧасти Цикл
		
		Для каждого Строка Из ТабличнаяЧасть.Значение Цикл
			
			РеглУчетПроведениеСервер.ДобавитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете(
				ДополнительныеСвойства, 
				Организация, 
				Строка.ДатаОтражения);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

//-- НЕ УТ

#КонецОбласти

#КонецОбласти

#КонецЕсли