---
title: Referee comments for SIIMS
---

## Editor's letter
Dear Prof. Marsland,

Your manuscript, "Differential invariant signatures for planar Lie group transformations of images," submitted to the SIAM Journal on Imaging Sciences, has completed this round of review. Though we can't accept it for publication at this time, we encourage you to read the referee reports and revise the paper following the suggestions outlined.

When you submit your revision include a detailed response to the reviewers.

If you do not intend to make changes and send a revised version of the paper, please let us know by return email, with a cc: to siims@siam.org. Otherwise, we are asking that you complete your revision within 4 weeks, and to be sure to let us know if you require more time.

Note: A second email will follow, which will include a link that you, as the corresponding author, can use when you're ready to submit the revised version. Do not forward the follow-up email to anyone else as the link is for your use exclusively, and allows access to your account.

Best regards,

Carola-Bibiane Schoenlieb
Associate Editor
SIAM Journal on Imaging Sciences

------------------------------------------------------------------------------

### Editor (Remarks to the Author):

The reviewers raise concerns of novelty of the paper and the lack of a clear objective of what the authors aim to achieve in the paper, referring to comprehensive results on the topic by Peter Olver and others. Without a significant effort from the authors part to address these issues I do not recommend publication in SIIMS.

I suggest the authors to follow the recommendations of the reviewers and carefully consider their recommendations, in particular concerning a new section with numerical experiments and practical
applications.

## Referee comments
### Referee #1 (Remarks to the Author):

In this paper the authors consider an approach to image recognition that consists in representing the images by means of their invariant signatures with respect to a group of transformations, and then compare the signatures in place of the images. The representation by means of these signatures remains invariant under the action of the group of transformations.
The signature of an image is a surface in 3D, and the comparison of two images reduces to the determination of whether the two corresponding signatures surfaces are the same.

In the case of objects represented by their boundary curves, this approach was proposed by Calabi et al [1998] and improved in Hoff and Olver [2013], with applications to synthetic curves with noise and to CT medical imaging. These references contain the mathematical ideas behind this method.

The authors of the paper under review discuss three different approaches for deriving signatures of grey-scale images, and propose how to construct in practice signatures of these images. Several different transformation groups are considered. Generalisations to colour-images are discussed. This part of the paper is valuable and could be useful in the development of new methods.

The main weakness of the paper is that the actual implementation and the practical use of this methodology through the numerical computation of the signature surfaces for digital images is not addressed, and remains an open problem.
Another open question is the actual comparison of the obtained signature surfaces for different images, there is no mention of the type of distance to be used for comparing the signatures and no demonstration that the overall method would actually work in practice.
So while the ideas might be valuable, we are left with the question of whether possible methods based on these ideas might or might not be of practical importance.
There is no evidence and no indication that such method would work on practical applications.

I do not recommend the paper to be published in its present form.
As a minimum the authors should consider some numerical examples, perhaps with synthetic images or surfaces, that show some of the potential benefits of the approach in the context of image recognition or for solving other image processing tasks.

Detailed comments:
- [x] line 5: relativele
*huh? fine as is*
- [x] lines 122 to 124 this sentence is vague, "when considered alone" what does it mean? "without further constraints"?
*Reworded to make intention clear*
- [x] Figure 3 (d): this figure does not show very much, what do we see here? The figure should be improved or removed.
*Added description to clarify*
- [ ] Section 1.4: The historical remarks are in chronological order but not the references. It seems that the work of Lie was enabled by work done in 1929, in 1984 and in 1928!
- [x] line 192 computing -> computed
- [ ] line 203: a reference to the book on moving frames by Liz Mansfield should be added.
- [x] line 237 "." should be moved at the end of the previous formula
- [x] line 244: "similarity transformations" could be misunderstood, suggest to use "transformations by Sim(2)"
- [x] line 244: backslash \emph{relative}
- [ ] lines 260 and 261: is this ment to be the definition of transvectant? It is very unclear.
- [ ] line 264 and following: from this explanation it is very unclear what is Cayley's Omega Process and what it means to be a relative invariant, things are much clearer in "Lectures on moving frames" by P. Over, http://www-users.math.umn.edu/~olver/mf_/mfm.pdf. Perhaps this introductory part should be shorted down to a minimum referring to the literature.
*That document doesn't touch transvectants at all*
- [ ] line 308: Table 1 and 2 shows -> show
- [ ] line 314: "Recall that invariants .." perhaps could add a reference here.
- [ ] lines 348 to 350: I do not understand this sentence! What does it mean that a Lie group has a homogeneous space? What does it means that a frame of reference can be applied on the manifold structure of the group? What is a frame of reference in this context?
- [ ] line 353 group act freely -> group to act freely
- [ ] line 361: please clarify the notation here, it seems that F could be the prolonged group action, what is the notation for the group action, just "\cdot"? F is introduced without definition in line 361. But F could also be a generic function defined on the manifold that we are trying to "invariantize". An example is the case when F is the coordinate function Z_i:M ->R
- [ ] lines 340 to 381: I found this introduction to moving frame impossible to understand without using the literature. This part should be either substantially improved or reduced to a minimum including appropriate references.
- [ ] Sections 4.1 to 4.5 contain examples where the invariant signatures surfaces are constructed for certain Lie groups of interest, possibly some of these examples have been published somewhere before in the literature on moving frames, if so references should be included here. Some of the formulae of section 4 are rather daunting and should be moved to an appendix shortening the main body of the paper.


### Referee #2 (Remarks to the Author):

The article under review is more of the nature of a survey than an original contribution. Most of the differential invariants presented can already be found in the literature, or straightforwardly constructed using the basic techniques. The paper discusses known methods for generating differential invariants based on tensors, on classical invariant theory (transvectants), and on the modern approach to moving frames. (Lie's infinitesimal method is not used.)

The basic setting for the results is a function u : R^2 -> R^k representing a 2D image. Here k=1 for black & white and >1 for colour, although the latter case is not developed in any detail. The paper studies a hierarchy of basic transformation groups acting on R^2, starting with translations, and then gradually introducing scaling, rotations, equiaffine, affine, and conformal maps, and projective transformations. In each case, a generating system of differential invariants is derived. The authors then select 3 of these - the lowest order ones - to construct what they call an incomplete differential invariant signature. Unlike the complete signatures derived using the Cartan or moving frame method, these may not uniquely characterize the image up to group transformations, although characterizing images that possess the same signature is a difficult and unresolved problem. The number 3 is chosen so that the graphs of the signature map s : R^2 -> R^3 can be visualized, and several plots are of these, corresponding to a single sample image, are included. However, it is unclear to me what one is supposed to glean from these plots. Also, there is no attempt to determine how good a classifier the resulting signatures might be, which is the fundamental question underlying their utility in image processing.

Aside from a brief concluding paragraph on page 27, the paper does not discuss the numerical computation of the differential invariants, which will be essential for any practical use of these signatures. (The test function used to generate the signature graphs is smooth, and hence computing its differential invariants is straightforward to do symbolically.) How much a priori smoothing, and what techniques are to be employed for this is also of critical importance for any practical implementations. As the authors state in their abstract: "A full consideration of how these signatures could be used in practice will require effective methods to numerically approximate derivatives effectively for images." (The repeat of "effective" should be avoided.)

In conclusion, while the paper could serve as useful reference for further potential applications in image processing, it is not clear to me that there is enough new here to justify publication in SIIMS, especially in the absence of any practical implementations, numerical methods, or experiments on actual images.

Specific comments:

- [ ] l. 28: I am not sure why the authors say "vary independently", as objects experience coupled motions as the camera is moved.
- [ ] l. 124-125: See Kruglikov, B., Lychagin, V., Global Lie--Tresse theorem, Selecta Math.; 22 (2016) 1357-1411 for general results on rational differential invariants for algebraic group actions.
- [ ] l. 244: misprint at the end of the line.
- [ ] l. 348 While the method of moving frames was developed extensively by Cartan, the modern approach based on equivariant maps that is used here does not appear in Cartan, but was introduced in the paper Fels, M., Olver, P.J., Moving coframes. II. Regularization and theoretical foundations, Acta Appl. Math. 55 (1999), 127-208.
- [ ] l. 432-440: it would be worth explaining how the moving frame-based Replacement Theorem (see the above reference) can be used to easily rewrite any differential invariant in terms of the moving frame differential invariants.
- [ ] Section 4.4: the authors should relate their projective differential invariants with those in the cited 2019 paper by Li et. al.


### Referee #3 (Remarks to the Author):

I had a very difficult time reviewing this paper. The theme of the paper is object recognition, which leads the authors to look for invariants of the given image to various Lie group transformations. As has been argued by others in the field, one should look for local differential invariants. The authors consider a number of methodologies for constructing such invariants for various groups of interest. This is beautifully written and explained, and I believe the paper is technically correct.

My problem is as follows. Why are they doing this? One reason is clearly the mathematics is elegant, which is reason enough. The issue here is that I am not sure now the theory described in the paper really goes beyond the many works of Peter Olver on the subject, who is probably the world's authority of the theory of differential invariants, as well as their application to computer vision and in particular, image recognition.
I know that Olver and collaborators utilized such theory for the outlines of objects and in the present work it is applied to images, but it does not seem one needs any major technical breakthrough to accomplish this.

All this would be fine, if this really could be applied to real-world image recognition problems. First of all, in the paper under review, we are talking about 2D imagery. In computer vision, most of the problems of interest are 3D. But even given this, the example given in the text to which the various methods are applied is very simplistic and certainly not convincing. Real images have NOISE, and this is why the differential invariant approach going back to the 1990's never really caught on for practical applications.

So I am not sure what to say or to recommend. I think that the paper offers an excellent survey for constructing differential invariants in a very well-written, cogent manner. I enjoyed reading it. On the other hand, I am very skeptical if these ideas could ever be applied to genuine computer vision problems. Certainly the example presented here, does not make their case.

So let me make the following suggestion. Why not try to apply the theory presented to a real noisy image (there are many on the web) and perhaps compare it to some other methods in the literature to show the superiority of differential invariant approach. This would make a much stronger contribution and perhaps even convince others to try out their proposed image recognition approach.