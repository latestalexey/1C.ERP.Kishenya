#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.УстановкаЗначенийНефинансовыхПоказателей.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения по регистрам
	РегистрыСведений.ЗначенияНефинансовыхПоказателей.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Перем МенеджерВТ;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Показатели = Новый Массив;
	Если ВидОперации = Перечисления.ВидыОперацийУстановкиЗначенийНефинансовыхПоказателей.ВводЗначенийПоШаблону Тогда
		Если ЗначениеЗаполнено(ШаблонВвода) Тогда
			Документы.УстановкаЗначенийНефинансовыхПоказателей.ПодготовитьТаблицыШаблона(ШаблонВвода, МенеджерВТ);
			ВидПериода = Документы.УстановкаЗначенийНефинансовыхПоказателей.ВидПериодаФормыДокумента(ШаблонВвода, МенеджерВТ);
			Показатели = ШаблонВвода.ПоказателиШаблона.ВыгрузитьКолонку("Показатель");
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(НефинансовыйПоказатель) Тогда
			Документы.УстановкаЗначенийНефинансовыхПоказателей.ПодготовитьТаблицыШаблона(НефинансовыйПоказатель, МенеджерВТ);
			ВидПериода = Документы.УстановкаЗначенийНефинансовыхПоказателей.ВидПериодаФормыДокумента(НефинансовыйПоказатель, МенеджерВТ);
			Показатели.Добавить(НефинансовыйПоказатель);
		КонецЕсли;
	КонецЕсли;
	
	Если ВидПериода = "ДействуетС" Тогда
		ПредставлениеПериода = НСтр("ru='Действует с %1';uk='Діє з %1'");
		ПредставлениеПериода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеПериода, Формат(НачалоПериода, "ДЛФ=D"));
	ИначеЕсли ВидПериода = "Период" Тогда
		ПредставлениеПериода = НСтр("ru='Период с %1 по %2';uk='Період з %1 по %2'");
		ПредставлениеПериода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									ПредставлениеПериода, Формат(НачалоПериода, "ДЛФ=D"), Формат(ОкончаниеПериода, "ДЛФ=D"));
	Иначе
		Массив = Новый Массив;
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Массив, СтрокиДокумента.ВыгрузитьКолонку("Период"), Истина);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Массив, КолонкиДокумента.ВыгрузитьКолонку("Период"), Истина);
		Список = Новый СписокЗначений;
		Список.ЗагрузитьЗначения(Массив);
		Список.СортироватьПоЗначению();
		Если Список.Количество() Тогда
			МинДата = Список[0].Значение;
			МаксДата = Список[Список.Количество() - 1].Значение;
			ПредставлениеПериода = НСтр("ru='Периоды с %1 по %2';uk='Періоди з %1 по %2'");
			ПредставлениеПериода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										ПредставлениеПериода, Формат(МинДата, "ДЛФ=D"), Формат(МаксДата, "ДЛФ=D"));
		КонецЕсли;
	КонецЕсли;
	
	ПредставлениеНефинансовыхПоказателей = СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(Показатели, ", ");
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Перем МенеджерВТ;
	
	ПроверенныеРеквизитыОбъекта = Новый Массив;
	Если ВидОперации = Перечисления.ВидыОперацийУстановкиЗначенийНефинансовыхПоказателей.ВводЗначенийПоШаблону Тогда
		ПроверенныеРеквизитыОбъекта.Добавить("НефинансовыйПоказатель");
		Документы.УстановкаЗначенийНефинансовыхПоказателей.ПодготовитьТаблицыШаблона(ШаблонВвода, МенеджерВТ);
		ВидПериода = Документы.УстановкаЗначенийНефинансовыхПоказателей.ВидПериодаФормыДокумента(ШаблонВвода, МенеджерВТ);
	Иначе
		ПроверенныеРеквизитыОбъекта.Добавить("ШаблонВвода");
		Документы.УстановкаЗначенийНефинансовыхПоказателей.ПодготовитьТаблицыШаблона(НефинансовыйПоказатель, МенеджерВТ);
		ВидПериода = Документы.УстановкаЗначенийНефинансовыхПоказателей.ВидПериодаФормыДокумента(НефинансовыйПоказатель, МенеджерВТ);
	КонецЕсли;
	
	Если ВидПериода <> "Период" Тогда
		ПроверенныеРеквизитыОбъекта.Добавить("ОкончаниеПериода");
	КонецЕсли;
	
	Если ВидПериода = "Нет" Тогда
		ПроверенныеРеквизитыОбъекта.Добавить("НачалоПериода");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ПроверенныеРеквизитыОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
