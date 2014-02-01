com.isel.si1314.asi
===================
ISEL MEIC si1314 ASI Trabalho Final

===================
ToDo
	Esquema Logico Global:
		Produto(Id[PK],IdFornecedor[FK],Codigo,Tipo,Designacao,Preco,QuantidadeStock,QuantidadeStockMin)
		Fornecedor(Id[PK],Numero,Nome,Morada)
		???? Tipo(Id[PK],Codigo,Nome) ????
	Esquema Fragmentacao
		Particao Vertical:
			ProdutoSede(Id[PK],IdFornecedor[FK],Codigo,Tipo,Designacao,Preco,QuantidadeStock,QuantidadeStockMin)
			ProdutoLojas(Id[PK],Codigo,Preco,QuantidadeStock)
		Particao Horizontal:
			ProdutoLojas1=SELECAO{tipo='CS'}(ProdutoLojas)
			ProdutoLojas2=SELECAO{tipo='HD'}(ProdutoLojas)
			
	ASIVesteSedeAppLayer.SedeServico
        //TODO: LOGICA DE NEGOCIO/ACESSO A DADOS
	QueueVendas.VendaServico
		//TODO: tratar as vendas nas lojas como na sede, contendo um produto cada uma?
		foreach (var item in ordem.vendaItems)
		{
            if (item != null)//TODO: FIX THIS, ordem.vendaItems vem com elementos vazios, limpar no cliente antes de enviar...		
		//...
			cl.registaVenda(venda);//TODO: Neste cenario com varios produtos numa venda fara sentido colocar este ciclo dentro de uma transacção?
===================
