#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если Вид = Перечисления.ВидыУпаковочныхЛистов.Исходящий Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Код");
	КонецЕсли;
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.ВыводитьНомераСтрок = Истина;
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ,ПараметрыПроверки);
	НоменклатураСервер.ПроверитьКоличествоПоСериям(ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.УпаковочныйЛист),
		Отказ);
	УпаковочныеЛистыСервер.ПроверитьЗаполнениеТЧСУпаковочнымиЛистами(ЭтотОбъект, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов, Отказ);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Код) Тогда
		Код = Документы.УпаковочныйЛист.ПолучитьКодНового();
	КонецЕсли;
	
	ВсегоМест = УпаковочныеЛистыСервер.КоличествоМестВТЧ(Товары);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли