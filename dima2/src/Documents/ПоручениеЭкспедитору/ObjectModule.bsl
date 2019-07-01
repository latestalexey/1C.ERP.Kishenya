#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Массив") Тогда
		Для Каждого Основание Из ДанныеЗаполнения Цикл
			Если ОбщегоНазначения.ЭтоДокумент(Основание.Метаданные()) Тогда
				НоваяСтрока = Основания.Добавить();
				НоваяСтрока.Основание = Основание;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Склады") Тогда
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "ЭтоГруппа") Тогда
			ВызватьИсключение НСтр("ru='Не предусмотрен ввод поручения экспедитору на основании группы складов.';uk='Не передбачено введення доручення експедитору на підставі групи складів.'");
		Иначе
			Склад = ДанныеЗаполнения;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Партнеры")
		Или ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
		Пункт = ДанныеЗаполнения;
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверямыхРеквизитов = Новый Массив;
	Если СпособДоставки = Перечисления.СпособыДоставки.ПоручениеЭкспедиторуВПункте Тогда
		МассивНепроверямыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверямыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ДоставкаТоваров.ОтразитьСостояниеДоставки(Ссылка, Отказ);
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ДоставкаТоваров.ОтразитьСостояниеДоставки(Ссылка, Отказ, Истина);
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если СпособДоставки = Перечисления.СпособыДоставки.ПоручениеЭкспедиторуВПункте Тогда
		Склад = Справочники.Склады.ПустаяСсылка();
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли