# ACBrTests

## Introdu��o

Algumas informa��es �teis ao criar testes unit�rios. N�o s�o regras.

## Como nomear unidades de classes de testes (Delphi/Lazarus)

Podem ser nomeadas com o nome da classe e o sufixo TestsUnit por exemplo:

* [NomeDaClasseTestsUnit]

## Como nomear as classes de testes

As classes de teste podem ser nomeadas com o nome da classe e o sufixo Testes (ou Tests) por exemplo:

* [NomeDaClasseTestes]
* [NomeDaClasseTests]

## Como nomear os testes em si

Parece haver um consenso que os nomes dos testes devem:

1. Ser curto, mas descritivo o suficiente para identific�-lo mesmo por quem n�o est� acostumado com os testes;
2. Descrever, se poss�vel, a **a��o**, o **estado** do objeto testado e o **objetivo** do teste;
3. Descrever o resultado esperado;

Mas tamb�m queremos que os testes sobrevivam ao tempo. Isto �, se uma classe ou m�todo for renomeada, n�o gostar�amos que nosso teste tamb�m precise ser renomeado para fazer sentido.

Assim, ao inv�s de pensar nas entidades (classes, functions, etc..) que est�o sendo testadas, pense em como descreveria o teste para uma pessoa que n�o � programador mas entende o "dom�nio" do problema. Por exemplo, se est� criando testes para sua classe de vendas, como explicaria o teste para um vendedor. Se � uma classe de c�lculo de impostos, como explicaria o teste para um contador.

Dessa forma alguns exemplos de nomes de testes s�o:

* Purchase_without_funds_is_not_possible
* Delivery_with_a_past_date_is_invalid
* Should_Increase_Balance_When_Deposit_Is_Made
* Add_credit_updates_customer_balance

### **Quando n�o consigo pensar num bom nome**

Por outro lado, quando se fica na d�vida sobre como nomear os testes, pode ser �til seguir o padr�o abaixo.
Esse padr�o resiste menos a refactorings, mas talvez � bem �til para criar testes com nomes eficazes.

[UnidadeDeTrabalho_EstadoSendoTestado_ResultadoEsperado]

Neste caso:

* **UnidadeDeTrabalho** pode ser uma entidade, m�todo, uma classe ou v�rias classes. Mas representa o que est� sendo testado neste teste espec�fico. Deve-se tomar cuidado ao incluir o nome da entidade/m�todo no teste, em especial caso exista alguma possibilidade de este m�todo ser renomeado depois.
* **EstadoSendoTestado** descreve as condi��es do teste ou a a��o da unidade do trabalho
* **ResultadoEsperado** descreve ent�o como aquela unidade de trabalho deve se comportar

Isso sugere nomes como:

* WEBServer_LoginComSenhaVazia_DeveFalhar
* WEBServer_LoginComUsuarioVazio_DeveFalhar
* WEBServer_LoginComSenhaeUsuarioVazios_DeveFalhar
* Soma_NumeroNegativoNo1oParametro_GeraException
* Soma_ValoresSimples_SaoCalculados

## Fontes

Alguns artigos consultados:

* <https://enterprisecraftsmanship.com/posts/you-naming-tests-wrong/>
* <https://stackoverflow.com/questions/155436/unit-test-naming-best-practices>
* <http://osherove.com/blog/2005/4/3/naming-standards-for-unit-tests.html>
* <http://testing.bredex.de/naming-conventions-for-test-cases.html>
* <https://code.google.com/p/robotframework/wiki/HowToWriteGoodTestCases#Test_case_names>
* <http://sysgears.com/articles/the-art-of-writing-effective-and-transparent-test-cases/>
