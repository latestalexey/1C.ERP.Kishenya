#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ Владелец.Пустая() Тогда
		РеквизитыВидаРЦ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Владелец, "ПараллельнаяЗагрузка,ВариантЗагрузки");
		ВремяРаботыДоступно = (РеквизитыВидаРЦ.ПараллельнаяЗагрузка 
								И РеквизитыВидаРЦ.ВариантЗагрузки = Перечисления.ВариантыЗагрузкиРабочихЦентров.Синхронный);
	Иначе
		ВремяРаботыДоступно = Ложь;
	КонецЕсли; 
	
	Если НЕ ВремяРаботыДоступно Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВремяРаботы");
		МассивНепроверяемыхРеквизитов.Добавить("ЕдиницаИзмерения");
	КонецЕсли; 
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли