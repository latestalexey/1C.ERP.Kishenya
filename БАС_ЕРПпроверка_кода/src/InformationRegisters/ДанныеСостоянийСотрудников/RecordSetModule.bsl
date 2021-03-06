#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// Необходимо определить набор ключевых измерений для записи связанного набора записей.
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеНабора.Сотрудник
	|ИЗ
	|	РегистрСведений.ДанныеСостоянийСотрудников КАК ДанныеНабора
	|ГДЕ
	|	ДанныеНабора.Регистратор = &Регистратор";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	РезультатЗапроса = Запрос.Выполнить();
	
	Сотрудники = Новый Массив;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Сотрудники.Добавить(Выборка.Сотрудник);
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("КлючевыеИзмерения", Сотрудники);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// Перезаписываем состояния по сотрудникам, являющимися измерениями этого набора записей (по данному регистратору) до
	// записи и после.
	
	Сотрудники = ОбщегоНазначения.ВыгрузитьКолонку(ЭтотОбъект, "Сотрудник", Истина);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Сотрудники, ДополнительныеСвойства.КлючевыеИзмерения, Истина);
	
	СостоянияСотрудников.ОбновитьСостоянияСотрудников(Сотрудники);
	
КонецПроцедуры

#КонецОбласти
	
#КонецЕсли